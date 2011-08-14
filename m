Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab1HNXuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 19:50:07 -0400
Received: from lo.gmane.org ([80.91.229.12]:58186 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab1HNXuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 19:50:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oliver <oliver@first.in-berlin.de>
Subject: ERESTARTNOINTR, when compiling/linking shotwell with -pg
Date: Sun, 14 Aug 2011 23:45:51 +0000 (UTC)
Message-ID: <loom.20110815T013533-483@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 85.178.14.47 (Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.18) Gecko/20110628 Ubuntu/10.04 (lucid) Firefox/3.6.18)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I added "-pg" switches to shotwell-Makefile and when running my
profiling-shotwell, when quitting it, it hangs temporarily.

"temporarily" can be between about 9 and more than 38 minutes (any other value
might also be possible... but these are some min/max numbers I experienced. In
case of 38 minutes it was "only" 38 minutes, because I killed shotwell after
that time.)

Without the "-pg" switch I did not got that problem.

Strace tells me, that the profiling timer expired.

Here some lines of strace, which I got, when the programs hangs:

  
  [...]
  clone(child_stack=0, flags=CLONE_PARENT_SETTID|SIGCHLD,
parent_tidptr=0x7fffdcc6ac8c) = ? ERESTARTNOINTR (To be restarted)
  --- {si_signo=SIGPROF, si_code=SI_KERNEL, si_value={int=1, ptr=0x1}}
(Profiling timer expired) ---
  rt_sigreturn(0x1b)                      = 56
  clone(child_stack=0, flags=CLONE_PARENT_SETTID|SIGCHLD,
parent_tidptr=0x7fffdcc6ac8c) = ? ERESTARTNOINTR (To be restarted)
  --- {si_signo=SIGPROF, si_code=SI_KERNEL, si_value={int=1, ptr=0x1}}
(Profiling timer expired) ---
  rt_sigreturn(0x1b)                      = 56
  [...]



Using current standard installation of Arch linux on AMD-64 dual-core (no custom
kernel).


Any idea on fixing this?

As far as I could find out, this seems to be a kernel-problem.
So it's, why I let you know it here.

Ciao,
   Oliver

