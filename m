Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031887Ab2COQq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:46:27 -0400
Received: from 1wt.eu ([62.212.114.60]:63321 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031870Ab2COQqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:46:16 -0400
Date: Thu, 15 Mar 2012 17:42:55 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: stable-3.0: s390 build breakage [was: Linux 3.0.24]
Message-ID: <20120315164255.GQ2264@1wt.eu>
References: <20120312203451.GA16773@kroah.com> <4F61C911.5010204@suse.cz> <20120315150947.GI7928@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="E39vaYmALEf/7YXx"
Content-Disposition: inline
In-Reply-To: <20120315150947.GI7928@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2012 at 08:09:47AM -0700, Greg KH wrote:
> On Thu, Mar 15, 2012 at 11:48:49AM +0100, Jiri Slaby wrote:
> > On 03/12/2012 09:34 PM, Greg KH wrote:
> > > I'm announcing the release of the 3.0.24 kernel.
> > ...
> > > Heiko Carstens (1): compat: fix compile breakage on s390
> > 
> > It looks like we need the same fix as for 2.6.32.59:
> > arch/s390/kernel/setup.c: In function 'setup_addressing_mode':
> > arch/s390/kernel/setup.c:328: error: 'PSW32_ASC_PRIMARY' undeclared
> > (first use in this function)
> > arch/s390/kernel/setup.c:328: error: (Each undeclared identifier is
> > reported only once
> > arch/s390/kernel/setup.c:328: error: for each function it appears in.)
> 
> Ick.  What is the patch that should be applied here to resolve this?  I
> don't remember seeing it go by, but I could have missed it.

Here's the one-liner Heiko sent to me against this issue.

Willy


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-compat-Re-add-missing-asm-compat.h-include-to-fix-co.patch"

>From 25d31f767ae3a0352b3d553cdea5c38b68bc797c Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Mon, 5 Mar 2012 14:06:38 +0100
Subject: compat: Re-add missing asm/compat.h include to fix compile breakage on s390

From: Heiko Carstens <heiko.carstens@de.ibm.com>

For kernels < 3.0 the backport of 048cd4e51d24ebf7f3552226d03c769d6ad91658
"compat: fix compile breakage on s390" will break compilation...

Re-add a single #include <asm/compat.h> in order to fix this.

This patch is _not_ necessary for upstream, only for stable kernels
which include the "build fix" mentioned above.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/setup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 0b2573a..358e545 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -57,6 +57,7 @@
 #include <asm/ptrace.h>
 #include <asm/sections.h>
 #include <asm/ebcdic.h>
+#include <asm/compat.h>
 #include <asm/kvm_virtio.h>
 
 long psw_kernel_bits	= (PSW_BASE_BITS | PSW_MASK_DAT | PSW_ASC_PRIMARY |
-- 
1.7.2.1.45.g54fbc


--E39vaYmALEf/7YXx--
