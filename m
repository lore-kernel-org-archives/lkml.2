Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab2IBIKw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 04:10:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab2IBIKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 04:10:50 -0400
Date: Sun, 2 Sep 2012 10:10:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Xin Tong <xerox.time.tech@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: linux page table
In-Reply-To: <CALKntY00bG_wVpOGM_L9ENLqROgSO_TttXJeTkgkERdtpnwi_A@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1209021005090.22050@twin.jikos.cz>
References: <CALKntY00bG_wVpOGM_L9ENLqROgSO_TttXJeTkgkERdtpnwi_A@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Sep 2012, Xin Tong wrote:

> When a process is created in Linux, corresponding page table is
> implemented. In the current x86 linux, the page table is a multi-level
> page table and CR3 points to the first level of the page table.  I
> have 2 questions.
> 
> 1. is the value in CR3 virtual address or physical address ?

Physical, otherwise you will have chicken-egg problem.

> 2. can the address of the first level of the page table during a
> process's lifetime change ?

In theory it would be possible to implement. But I don't see a scenario 
when it might be useful.

> 3. can two different processes have their CR3 being the same value
> even though they have different first level page tables ?

Yes, if they are created by clone(CLONE_VM). In such case they share the 
same mm_struct, and therefore mm_struct->pgd (which is exactly what is 
loaded into cr3 in switch_mm()) is the same.

LKML is however very inappropriate list for such questions. Please ask on 
kernelnewbies list next time.

-- 
Jiri Kosina
SUSE Labs

