Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab1EBXoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:44:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932091Ab1EBXol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:44:41 -0400
Date: Mon, 2 May 2011 16:44:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: mmotm 2011-04-29 - wonky VmRSS and VmHWM values after swapping
Message-Id: <20110502164430.eb7d451d.akpm@linux-foundation.org>
In-Reply-To: <8185.1304347042@localhost>
References: <201104300002.p3U02Ma2026266@imap1.linux-foundation.org>
	<49683.1304296014@localhost>
	<8185.1304347042@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 May 2011 10:37:22 -0400
Valdis.Kletnieks@vt.edu wrote:

> On Sun, 01 May 2011 20:26:54 EDT, Valdis.Kletnieks@vt.edu said:
> > On Fri, 29 Apr 2011 16:26:16 PDT, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2011-04-29-16-25 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> >  
> > Dell Latitude E6500 laptop, Core2 Due P8700, 4G RAM, 2G swap.Z86_64 kernel.
> > 
> > I was running a backup of the system to an external USB hard drive.
> 
> Is a red herring.  Am seeing it again, after only 20 minutes of uptime, and so
> far I've only gotten 1.2G or so into the 4G ram (2.5G still free), and never
> touched swap yet.
> 
> Aha! I have a reproducer (found while composing this note).  /bin/su will
> reliably trigger it (4 tries out of 4, launching from a bash shell that itself
> has sane VmRSS and VmHWM values).  So it's a specific code sequence doing it
> (probably one syscall doing something quirky).
> 
> Now if I could figure out how to make strace look at the VmRSS after each
> syscall, or get gdb to do similar.  Any suggestions?  Am open to perf/other
> solutions as well, if anybody has one handy...
> 

hm, me too.  After boot, hald has a get_mm_counter(mm, MM_ANONPAGES) of
0xffffffffffff3c27.  Bisected to Pater's
mm-extended-batches-for-generic-mmu_gather.patch, can't see how it did
that.

