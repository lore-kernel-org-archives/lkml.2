Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab0G2Tz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:55:59 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:36868 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755287Ab0G2Tz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:55:58 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: JzCH1PIVM1k6jHZyMRguU4BuTzRwplpAbvQ46xDoZD3pKdk
 2kZmbh67Mwduvp0IzMRgNjtg01UKlMo70TQNWwn4r4gY0adXXj0bKOD_E8QD
 hKmAbpx8MEV6CuZnIqGNDqNejw3.C7qSR9x8fojiio6LdcbKJXVZ4trd_Xyx
 IyllAE6UGBUKrSnF4ao_bCp28pKoZhyiTwSXVyrFDcXzAry6xhYufG0nsRfY
 0p0_QuqOzCAjQk7M2UC1vfVXeQU4B
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 29 Jul 2010 14:55:53 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
In-Reply-To: <20100729183320.GH18923@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1007291438290.21024@router.home>
References: <AANLkTinXmkaX38pLjSBCRUS-c84GqpUE7xJQFDDHDLCC@mail.gmail.com> <alpine.DEB.2.00.1007281005440.21717@router.home> <20100728155617.GA5401@barrios-desktop> <alpine.DEB.2.00.1007281158150.21717@router.home> <20100728225756.GA6108@barrios-desktop>
 <alpine.DEB.2.00.1007291038100.16510@router.home> <20100729161856.GA16420@barrios-desktop> <alpine.DEB.2.00.1007291132210.17734@router.home> <20100729170313.GB16420@barrios-desktop> <alpine.DEB.2.00.1007291222410.17734@router.home>
 <20100729183320.GH18923@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010, Russell King - ARM Linux wrote:

> And no, setting the sparse section size to 512kB doesn't work - memory is
> offset by 256MB already, so you need a sparsemem section array of 1024
> entries just to cover that - with the full 256MB populated, that's 512
> unused entries followed by 512 used entries.  That too is going to waste
> memory like nobodies business.

SPARSEMEM EXTREME does not handle that?

Some ARMs seem to have MMUs. If so then use SPARSEMEM_VMEMMAP. You can map
4k pages for the mmap through a page table. Redirect unused 4k blocks to
the NULL page.

