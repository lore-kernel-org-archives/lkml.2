Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab1BDPHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 10:07:08 -0500
Received: from hiauly1.hia.nrc.ca ([132.246.10.84]:1440 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab1BDPHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 10:07:06 -0500
Date: Fri, 4 Feb 2011 10:07:03 -0500
From: John David Anglin <dave@hiauly1.hia.nrc.ca>
To: Meelis Roos <mroos@linux.ee>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38-rc3 regression on parisc: segfaults
Message-ID: <20110204150703.GA9254@hiauly1.hia.nrc.ca>
Reply-To: John David Anglin <dave.anglin@nrc-cnrc.gc.ca>
References: <20110203022420.A73F54E7B@hiauly1.hia.nrc.ca> <alpine.SOC.1.00.1102041150390.8218@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1102041150390.8218@math.ut.ee>
Organization: nrc.ca
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Feb 2011, Meelis Roos wrote:

> 2363  clone( <unfinished ...>
> 2349  <... futex resumed> )             = 1
> 2363  <... clone resumed> child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x460df4a8) = 2372
> 2349  --- SIGSEGV (Segmentation fault) @ 0 (0) ---
> 2372  rt_sigaction(SIGPIPE, {SIG_DFL, [], SA_RESTART},  <unfinished ...>
> 2349  write(1, "\33[56;1H\33[34h\33[?25h", 18 <unfinished ...>
> 
> Something futex-related. Full log temprarilty available at 
> http://www.cs.ut.ee/~mroos/aptitude-strace.txt

This is possibly the infamous COW bug.

> gdb does not seem to work well:

I think the segv is in the dynamic loader.  Try gdb on dynamic loader
and aptitude as run argument.  Also suggest adding /usr/lib/debug to
LD_LIBRARY_PATH.

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
