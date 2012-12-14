Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab2LNX2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:28:01 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63880 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab2LNX16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:27:58 -0500
Date: Fri, 14 Dec 2012 16:25:10 -0600
From: Rob Landley <rob@landley.net>
Subject: Minimum toolchain requirements?
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        torvalds@linux-foundation.org
X-Mailer: Balsa 2.4.11
Message-Id: <1355523910.18402.9@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the README and Documentation/Changes both say the kernel  
builds with gcc 3.2, this is no loner the case. In reality the new 3.7  
kernel no longer builds under unpatched gcc 4.2.1 (the last GPLv2  
release).

Building for i686 breaks with "arch/x86/kernel/cpu/perf_event_p6.c:22:  
error: p6_hw_cache_event_ids causes a section type conflict" (trivial  
workaround: patch kernel so CONFIG_BROKEN_RODATA defaults to y).  
Building for mips breaks with "arch/mips/lib/delay.c:24:5: warning:  
"__SIZEOF_LONG__" is not defined". (Introduced January 2007, gcc git  
commit 6a60f216c210e. Easy enough to add an equivalent to my toolchain.)

Over in my Aboriginal Linux project I've been patching both the kernel  
and my GPLv2 toolchain for a while to work around these random  
breakages (such as when sh4 decided it would only build with binutils  
2.20, which had only been out for 3 months at the time). But since I'm  
supposed to be catching Documentation stuff that falls through the  
cracks, if the docs are clearly out of date I should probably update  
them.

I'm still regression testing each new kernel release against gcc 4.2.1,  
binutils 2.17, and make 3.81 (I.E. the last GPLv2 release of each  
tool). My personal preference would be to upgrade Documentation/Changes  
to say "gcc 4.2.1 and binutils 2.17 are the oldest supported versions",  
and then try to push patches upstream that prevent the kernel from  
building on those. Unfortunately, when I try to push patches to make  
older toolchains work, the reception isn't exactly warm.

So I ask the question: what are the current minimum requirements to  
build the kernel?

Rob
