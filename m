Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab0JAHNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:13:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57211 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab0JAHNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vvDo7kXU4w2a3Xz66ksKRQbCeaIuA30QfSo6doP1IoMs/FqxLrkvqXAUgkfnaTvbbC
         Dn0I5CsTPjV3JZ7IR/tnvIx6S49sYXJc9OLd0m9qj9veu4IWY6Wx++fEkK6lXcvjRq0Z
         7DuDDO7H9reSbN3lI1m96bnhwYYr68mp1pZsk=
MIME-Version: 1.0
In-Reply-To: <1285916771-18033-3-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	<1285916771-18033-3-git-send-email-imunsie@au1.ibm.com>
Date: Fri, 1 Oct 2010 09:13:19 +0200
X-Google-Sender-Auth: YnoFJLtvW849IuRYZuQaw1NJzr8
Message-ID: <AANLkTi=VmSXN6XeD__nkQLJAYXzxOh6WEtW6-jjJcC4Q@mail.gmail.com>
Subject: Re: [PATCH 02/18] powerpc: Add CROSSBE_COMPILE to build big endian
 boot wrapper
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, Michal Marek <mmarek@suse.cz>,
        Albert Herranz <albert_herranz@yahoo.es>, paulus@samba.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 09:05, Ian Munsie <imunsie@au1.ibm.com> wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>
>
> Since the boot wrapper must be built by a big endian 32bit toolchain
> regardless of what the rest of the kernel is using introduce a new
> parameter to specify that toolchain - CROSSBE_COMPILE.
>
> We already have CROSS32_COMPILE which is already used for the boot
> wrapper, but it is also used to build the 32bit vdso which should be
> build in the same endianness as the rest of the kernel, so it is
> necessary to be able to specify the toolchain to build the boot wrapper
> separately from that used to build the vdso and again separately from
> that used to build the main kernel.
>
> CROSSBE_COMPILE should be pointed to a toolchain capable of targeting
> 32bit big endian powerpc, either specifically targetted at 32bit or
> bi-arch 64 and 32bit. If CROSSBE_COMPILE is not specified it will fall
> back to CROSS32_COMPILE to maintain compatibility with big endian
> targets.

Shouldn't the help text added by [PATCH 01/18]:

+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -329,3 +329,19 @@ config CHECK_CACHE_COHERENCY
       bool

 endmenu
+
+config ARCH_SUPPORTS_LITTLE_ENDIAN
+       bool
+
+config CPU_LITTLE_ENDIAN
+       bool "Build little endian kernel"
+       depends on ARCH_SUPPORTS_LITTLE_ENDIAN && EXPERIMENTAL
+       default n
+       help
+         This option selects whether a big endian or little endian kernel will
+         be built.
+
+         Note that if building a little endian kernel, CROSS_COMPILE must
+         point to a toolchain capable of targetting little endian powerpc,
+         while the toolchain specified by CROSS32_COMPILE must be capable of
+         targetting *BIG* endian PowerPC.

be updated here as well?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
