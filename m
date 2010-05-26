Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176Ab0EZBU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:20:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759158Ab0EZBU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:20:58 -0400
Date: Tue, 25 May 2010 18:20:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Subject: Re: linux-next: build warning in Linus'tree
Message-Id: <20100525182040.f1882d0a.akpm@linux-foundation.org>
In-Reply-To: <20100526110506.f2f4f22c.sfr@canb.auug.org.au>
References: <20100526110506.f2f4f22c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 11:05:06 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Linus,
> 
> Today's linux-next build (powerpc ppc64_defconfig) produced this warning:
> 
> lib/crc32.c:53:22: warning: "__LITTLE_ENDIAN" is not defined
> lib/crc32.c:53:22: warning: "__LITTLE_ENDIAN" is not defined
> In file included from fs/jfs/jfs_types.h:33,
>                  from fs/jfs/jfs_incore.h:26,
>                  from fs/jfs/file.c:22:
> fs/jfs/endian24.h:36:101: warning: "__LITTLE_ENDIAN" is not defined
> 
> and more of the same ...
> 
> Introduced by commit 4762bbc1a3a1f22095278b74dd1b8cee04858641 ("crc32:
> use __BYTE_ORDER macro for endian detection") and (probably) commit b3b77c8caef1750ebeea1054e39e358550ea9f55 ("endian: #define __BYTE_ORDER").
> 

hmpf.  Does this fix?

--- a/lib/crc32.c~a
+++ a/lib/crc32.c
@@ -26,6 +26,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/init.h>
+#include <asm/byteorder.h>
 #include <asm/atomic.h>
 #include "crc32defs.h"
 #if CRC_LE_BITS == 8
_

