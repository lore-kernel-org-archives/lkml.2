Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1GNTeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 15:34:09 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:37664 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753888Ab1GNTeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 15:34:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: soaNyAkVM1kDT5GWaiWt9xsOjDtCbdiTnjzM9cWFCNedMIi
 SWwxntyj7_6U7azw1KpGJ3hAMn2w5szcvPQzTjMO9vdvjkkqMyknSNjoxGi6
 Bl3VBiZ.ktVdHJ6ZASaHGHX1ViCQwtIkiv_vPz_HM_7pZoS.xLv6VjfLFDdx
 S68iQMW5SEBZUgRg90sfiYOf_H8qTyhsmSHbrtpO7e7Uw1UyEfYWbU7VE2uk
 7m4m3YQubXBblQmYrbhk6W0xQKIIOdsPsYvIEBDV4M3fIkxINZJWtmZX.fl9
 SlkZUB1.x69k_PJzNTvygKd9sPu_b_4Tg2bzUPRmtyqXC9WI9uhp8J34bEax
 9gShYwINfZUS1smY1KAeORDrm
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 14 Jul 2011 14:34:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pintu Agarwal <pintu_agarwal@yahoo.com>
cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Memory allocation from ZONE_HIGHMEM ???
In-Reply-To: <1310625925.65469.YahooMailNeo@web162002.mail.bf1.yahoo.com>
Message-ID: <alpine.DEB.2.00.1107141432520.2923@router.home>
References: <1310625925.65469.YahooMailNeo@web162002.mail.bf1.yahoo.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-2109514762-1310672045=:2923"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-2109514762-1310672045=:2923
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 13 Jul 2011, Pintu Agarwal wrote:

> I have a question regarding kernel memory allocation(using kmalloc)=A0fro=
m ZONE_HIGHMEM zone.

kmalloc does not allocate from ZONE_HIGHMEM.

> But I want to specifically allocate=A0pages from ZONE_HIGHMEM instead of =
Normal zone.
> How to explicitly do that in kernel?

You must use the page allocator. The slab allocators cannot use
ZONE_HIGHMEM. ZONE_HIGHMEM contains pages that are not directly accessible
from the processor.

---1463811839-2109514762-1310672045=:2923--
