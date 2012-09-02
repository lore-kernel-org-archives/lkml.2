Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2IBS1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 14:27:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab2IBS1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 14:27:05 -0400
Date: Sun, 2 Sep 2012 20:26:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Xin Tong <xerox.time.tech@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: linux page table
In-Reply-To: <CALKntY1XnHG7BAnu4yYU_8iwDttAhuxqu1bBu7YuxXMP4nF+JQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1209022026100.20709@pobox.suse.cz>
References: <CALKntY00bG_wVpOGM_L9ENLqROgSO_TttXJeTkgkERdtpnwi_A@mail.gmail.com> <alpine.LRH.2.00.1209021005090.22050@twin.jikos.cz> <CALKntY1XnHG7BAnu4yYU_8iwDttAhuxqu1bBu7YuxXMP4nF+JQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2012, Xin Tong wrote:

> >> 3. can two different processes have their CR3 being the same value
> >> even though they have different first level page tables ?
> >
> > Yes, if they are created by clone(CLONE_VM). In such case they share the
> > same mm_struct, and therefore mm_struct->pgd (which is exactly what is
> > loaded into cr3 in switch_mm()) is the same.
> >
> 
> Is this the COW mechanism in linux. what if the cloned process need to
> have set of its own pages later. do the CR3s for the 2 processes
> become different at that point ?

That is a different story. COW is applied on fork() (i.e. spawning new 
process), not on clone(CLONE_VM) (i.e. spawning new thread).

-- 
Jiri Kosina
SUSE Labs
