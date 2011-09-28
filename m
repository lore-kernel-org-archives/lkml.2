Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab1I1Pv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:51:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47849 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754896Ab1I1Pv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:51:57 -0400
Message-ID: <1317225116.23682.6.camel@Joe-Laptop>
Subject: Re: linux-next: build failure after merge of the akpm tree
From: Joe Perches <joe@perches.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Date: Wed, 28 Sep 2011 08:51:56 -0700
In-Reply-To: <20110928192220.6d85ae23a2f2ef316139a310@canb.auug.org.au>
References: <20110928192220.6d85ae23a2f2ef316139a310@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.92- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 19:22 +1000, Stephen Rothwell wrote:
> After merging the akpm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from arch/powerpc/boot/stdio.c:12:0:
> arch/powerpc/boot/stdio.h:10:17: error: expected declaration specifiers or '...' before numeric constant
[]
> And went down hill from there (it produced hundreds of errors).

Well, I did say it was completely untested...

> Caused by commit a52af697aaeb ("treewide: use __printf not __attribute__
> ((format(printf,...)))").  Maybe because some of these files are part of
> the boot wrappers and are built (effectively) independently of the kernel
> itself.  Notice that arch/powerpc/boot/stdio.h does not include any
> kernel headers ...

The conversion was too comprehensive.

Probably most of the arch/... changes should be removed.
The arch/frv and arch/s390 changes look safe as they
are after #includes of kernel.h.

 arch/alpha/boot/misc.c                       |    3 +-
 arch/alpha/include/asm/console.h             |    3 +-
 arch/frv/include/asm/system.h                |    2 +-
 arch/ia64/include/asm/mca.h                  |    3 +-
 arch/m68k/include/asm/natfeat.h              |    3 +-
 arch/mn10300/include/asm/gdb-stub.h          |    5 +-
 arch/powerpc/boot/ps3.c                      |    3 +-
 arch/powerpc/boot/stdio.h                    |    5 +-
 arch/powerpc/include/asm/udbg.h              |    3 +-
 arch/s390/include/asm/debug.h                |   11 +--
 arch/um/include/shared/user.h                |    8 +-


