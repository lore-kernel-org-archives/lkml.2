Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab1GUSy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:54:59 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:24729 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753541Ab1GUSy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:54:57 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8RYuz.8VM1khB5RyKxJ6simU3UMu6cbYdlznsd3xiy3hWvG
 MwOCuZQ2pO3F6WgwghlvX8TBjnIHXvUYLkU5_nhO8z.NiPDtl1bIHbDjFE6m
 uo_h1gjB6dpyXNCEXkS5sXsw7FumDpHMtisA7tM7lfVMXtOajV7mNSSrSXNu
 IkMTNaRJiCGnoLRAeMNmFr4pyG8tTNr3rSsq7a263.qcvrZ1L6A61tkW1w9d
 ppRBwMuSSlM4opoL59ObG7qGj_6AvDXiJ2XDzKAHthBKPKcfsygEsEYjqGEt
 MxPF3sNZuPDgsuw1sRD5xwgCRd0iKVM7X7eXKA.Ph0oWZopX1xfYPZBOSdh2
 KeJysXM4ziz4RvnAs9wgwY7H3
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 21 Jul 2011 13:54:54 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Rabin Vincent <rabin@rab.in>
cc: penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: "slub: Rework allocator fastpaths" and slub debugging
In-Reply-To: <20110721184436.GA7474@debian>
Message-ID: <alpine.DEB.2.00.1107211351250.3995@router.home>
References: <20110721184436.GA7474@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011, Rabin Vincent wrote:

> Enabling slub debugging on linux-next throws up continuous apparently
> spurious "Redzone overwritten" reports, right from startup.  The start
> of a boot log is below (the rest of the log has more such reports).

Hmmm... I moved the page lock into the cmpxchg_double simulation for the
debug case after some complaints (last minute change). And now the
updating of the redzone etc is outside of the page lock and therefore not
synced... Somehow we need to move it into the critical section where the
page lock is held. Thanks.

