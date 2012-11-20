Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab2KTUdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:33:52 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45748 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2KTUdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:33:50 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1211201806580.2701@ionos>
References: <alpine.LFD.2.02.1211201806580.2701@ionos>
Date: Tue, 20 Nov 2012 15:33:49 -0500
Message-ID: <CA+5PVA67M-NW45vXCTW4GZkR26nELVoM=0hC=oT1LbXjfYp_EQ@mail.gmail.com>
Subject: Re: [GIT pull] perf fixes for 3.7
From: Josh Boyer <jwboyer@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 12:07 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Linus,
>
> please pull the latest perf-urgent-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus
>
> * Fix to lookup the installed breakpoint(s) on the correct cpu
> * Two fixes related to header printout (tools)
>
> Thanks,
>
>         tglx
>
> ------------------>
> Michael Neuling (1):
>       perf, powerpc: Fix hw breakpoints returning -ENOSPC
>
> Namhyung Kim (2):
>       perf header: Fix numa topology printing
>       perf tools: Fix strbuf_addf() when the buffer needs to grow

For perf to build on non-x86 architectures (or at least s390x and ppc64)
I think we still need:

http://thread.gmane.org/gmane.linux.kernel.cross-arch/15943

or at least the last patch in that set, otherwise we get build failures
due to uapi/unistd.h issues.  We also need:

http://article.gmane.org/gmane.linux.kernel.cross-arch/15874
http://article.gmane.org/gmane.linux.kernel.cross-arch/15926

because svm.h and vmx.h are x86 only headers.

Those patches above are what I'm carrying to fix the build fixes for
Fedora rawhide kernels and can be found here for those interested:

http://jwboyer.fedorapeople.org/pub/perf-uapi-fixes2.patch

josh
