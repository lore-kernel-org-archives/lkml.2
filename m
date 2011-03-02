Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab1CBPzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:55:36 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52357 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1CBPzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:55:35 -0500
Date: Wed, 2 Mar 2011 10:55:30 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the arm tree
In-Reply-To: <20110303011335.7a8dc21a.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.1103021049480.13483@xanadu.home>
References: <20110303011335.7a8dc21a.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011, Stephen Rothwell wrote:

> Hi Russell,
> 
> After merging the final tree, the linux-next 20110228 build (lots of arm
> configs) failed like this:
> 
> stat: cannot stat `arch/arm/boot/compressed/../Image': No such file or directory
> gcc-4.4.0-nolibc/arm-linux/bin/arm-linux-ld:--defsym _image_size=: syntax error
> 
> Presumably caused by commit d239b1dc093d551046a909920b5310c1d1e308c1
> ("ARM: 6746/1: remove the 4x expansion presumption while decompressing
> the kernel").

The fix would be this:

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 9d328be..3c0c68f 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -84,7 +84,7 @@ EXTRA_CFLAGS  := -fpic -fno-builtin
 EXTRA_AFLAGS  := -Wa,-march=all
 
 # Provide size of uncompressed kernel to the decompressor via a linker symbol.
-LDFLAGS_vmlinux := --defsym _image_size=$(shell stat -c "%s" $(obj)/../Image)
+LDFLAGS_vmlinux = --defsym _image_size=$(shell stat -c "%s" $(obj)/../Image)
 # Supply ZRELADDR to the decompressor via a linker symbol.
 ifneq ($(CONFIG_AUTO_ZRELADDR),y)
 LDFLAGS_vmlinux += --defsym zreladdr=$(ZRELADDR)

Russell: can you fold this fix in the original patch, or do you prefer I 
send you this fix separately?


Nicolas
