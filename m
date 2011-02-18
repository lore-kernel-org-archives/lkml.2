Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1BRL1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 06:27:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45660 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1BRL1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 06:27:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QR5ER27f8wEC805QdPp5F1g44tnPn8K2bFNAB9CGEdaf1Eor89KryA77vijutPih+y
         dPoCLFiUKJic2FIuRVuWFbf6hBg0MXvw3BaIhaetRWwNE4dBIpcS465MnZGX3RKSeZ0X
         wgZq6efjo6G6P+YGS4ncTmjyzjU64r+qUyR7M=
MIME-Version: 1.0
In-Reply-To: <4D5DB83D.80205@snapgear.com>
References: <4D5DB83D.80205@snapgear.com>
Date: Fri, 18 Feb 2011 12:27:41 +0100
X-Google-Sender-Auth: 1AASo7qaLEB8oR1mkkmiVn9piQo
Message-ID: <AANLkTin0X-ST=rZqwfCA0i5VGCh5ygYXyZFdndiDgR_2@mail.gmail.com>
Subject: Re: merge of m68knommu and m68k arch branches?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Steven King <sfking00@yahoo.com>,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Greg Ungerer <gregungerer@westnet.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 01:07, Greg Ungerer <gerg@snapgear.com> wrote:
> I would like to put up for discussion a merge of the m68knommu and
> m68k arch branches.
>
> Attached is a script and patch that does a kind of brute force
> simplistic merge of the directories and files. (Thanks to Stephen King
> <sfking@fdwdc.com> for the initial version of this script, and to
> Sam Ravnborg for the m68k includes merge script this was based on).
> Nothing outside of the arch/m68k and arch/m68knommu directories is
> touched, and in the end there is no more arch/m68knommu. To apply you
> simply run the script from the top of a current kernel git tree (I used
> 2.6.38-rc5 for testing) and then apply the patch.

Initial feedback:

--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -1,5 +1,5 @@
 ifdef CONFIG_MMU
-include arch/m68k/Makefile_mm
+include $(srctree)/arch/m68k/Makefile_mm
 else
-include arch/m68k/Makefile_no
+include $(srctree)/arch/m68k/Makefile_no
 endif

Don't you need to add "# CONFIG_MMU is not set" to all m68knommu
defconfig files?

Building...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
