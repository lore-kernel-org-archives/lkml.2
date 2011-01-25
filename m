Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab1AYFsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 00:48:12 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56781 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1AYFsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 00:48:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sQhd8/rccafhTPkKSYQOPK8ZgIZaNdeBO6tuS/3o7krU5VeEmkBKmfz1Eh7XBwTthQ
         U4O2QsEosoEICXpkColxRXzuHXlLayUOUSuJif/28ObY+SzMZ1/BxY0NPPS4w2GJIbxU
         G5Wubq5ixcG/BwuR304ag/N2G6LoAgQUu5A3k=
Date: Tue, 25 Jan 2011 13:48:00 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Harald Dunkel <harri@afaics.de>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kenrel.org
Subject: Re: [Patch] make installkernel configurable from command line (was
 Re: how to avoid that install.sh goes mad, if I am not root?)
Message-ID: <20110125054800.GC13618@cr0.nay.redhat.com>
References: <4D388A08.1010004@afaics.de>
 <19768.44428.482148.361069@pilspetsen.it.uu.se>
 <ihbvd1$jbj$3@dough.gmane.org>
 <4D3A03CA.2060507@afaics.de>
 <20110124102159.GD5510@cr0.nay.redhat.com>
 <19773.26066.137666.718852@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19773.26066.137666.718852@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 12:43:14PM +0100, Mikael Pettersson wrote:
>NAK -- this breaks existing setups which rely on /root/bin/installkernel
>being picked up automatically.
>
>Can you handle 'make INSTALLKERNEL=...' without breaking that please?

Yes, here we go.

--------->

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/Makefile b/Makefile
index 1f47495..44abded 100644
--- a/Makefile
+++ b/Makefile
@@ -327,7 +327,7 @@ OBJCOPY		= $(CROSS_COMPILE)objcopy
 OBJDUMP		= $(CROSS_COMPILE)objdump
 AWK		= awk
 GENKSYMS	= scripts/genksyms/genksyms
-INSTALLKERNEL  := installkernel
+INSTALLKERNEL  ?= /sbin/installkernel
 DEPMOD		= /sbin/depmod
 KALLSYMS	= scripts/kallsyms
 PERL		= perl
diff --git a/arch/x86/boot/install.sh b/arch/x86/boot/install.sh
index d13ec1c..c8c9a92 100644
--- a/arch/x86/boot/install.sh
+++ b/arch/x86/boot/install.sh
@@ -33,8 +33,8 @@ verify "$3"
 
 # User may have a custom install script
 
-if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
-if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
+if [ -x ~/bin/installkernel ]; then exec ~/bin/installkernel "$@"; fi
+if [ -x "${INSTALLKERNEL}" ]; then exec "${INSTALLKERNEL}" "$@"; fi
 
 # Default install - same as make zlilo
 
