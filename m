Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab2CENNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:13:30 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:54790 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab2CENN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:13:28 -0500
Date: Mon, 5 Mar 2012 14:13:23 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Tony Luck <tony.luck@intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        raven@themaw.net
Subject: Re: Build broken on s390 and ia64 [was: Linux 2.6.32.58]
Message-ID: <20120305131323.GB3627@osiris.boeblingen.de.ibm.com>
References: <20120304180911.GA7336@kroah.com>
 <4F54A46A.6000305@suse.cz>
 <20120305120241.GA3627@osiris.boeblingen.de.ibm.com>
 <4F54B618.1090301@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F54B618.1090301@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12030513-0542-0000-0000-0000012C664F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 01:48:24PM +0100, Jiri Slaby wrote:
> On 03/05/2012 01:02 PM, Heiko Carstens wrote:
> > On Mon, Mar 05, 2012 at 12:32:58PM +0100, Jiri Slaby wrote:
> >> Perhaps asm/compat.h should be included from linux/compat.h
> >> unconditionally...
> > 
> > If you do that you need to add #ifdef wrappers around the is_compat_task()
> > definitions in each arch that supports CONFIG_COMPAT. If that's all that's
> > needed that would be great!
> 
> I don't know, I haven't checked. It was just a shot in the dark. Maybe
> it's easier to revert the removal of asm/compat.h from s390 files. Could
> you bake a patch?

Sure:

>From f88668aaee256a331ea03c852c672d3ef7704208 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Mon, 5 Mar 2012 14:06:38 +0100
Subject: [PATCH] compat: Re-add missing asm/compat.h include to fix compile
 breakage on s390

For kernels < 3.0 the backport of 048cd4e51d24ebf7f3552226d03c769d6ad91658
"compat: fix compile breakage on s390" will break compilation...

Re-add a single #include <asm/compat.h> in order to fix this.

This patch is _not_ necessary for upstream, only for stable kernels
which include the "build fix" mentioned above.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/setup.c |    1 +
 1 file changed, 1 insertion(+)

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
1.7.9.2

