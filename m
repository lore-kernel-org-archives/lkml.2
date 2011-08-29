Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab1H2LUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:20:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55662 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1H2LUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:20:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] tpm: TCG_ATMEL should depend on HAS_IOPORT
Date: Mon, 29 Aug 2011 13:19:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        Jonas Bonn <jonas@southpole.se>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
References: <1312801699-17474-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1312801699-17474-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201108291319.54170.arnd@arndb.de>
X-Provags-ID: V02:K0:00zQo04a71QL82EUSCYQnIzhjLa+29g+G4F2vQR7TAc
 9WEDnrfIljcmBocPRqNbpf1/8p2QGPGMBK8NbBykyyAVy+IDiv
 nMv6CyfYp5mgpFxBc3mlTH//cTDtklm76+JkwqWKviE8gnO4bT
 qwHXxsnMG8f4JthSYMtdUOAVW53693V/t+gZobkKs1imvfI6as
 bVoredW46xDCzsn6spY3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 August 2011, Geert Uytterhoeven wrote:
> drivers/char/tpm/tpm_atmel.h: In function ‘atmel_get_base_addr’:
> drivers/char/tpm/tpm_atmel.h:129: error: implicit declaration of function ‘ioport_map’
> drivers/char/tpm/tpm_atmel.h:129: warning: return makes pointer from integer without a cast
> 
> The code in tpm_atmel.h supports PPC64 (using the device tree and ioremap())
> and "anything else" (using ioport_map()). However, ioportmap() is only
> available on platforms that set HAS_IOPORT.
> 
> Although PC64 seems to have HAS_IOPORT, a "depends on HAS_IOPORT" should work,
> but I think it's better to expose the special PPC64 handling explicit using
> "depends on PPC64 || HAS_IOPORT".
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

FWIW, I've now got a first prototype of the HAS_IOPORT rework in
http://git.kernel.org/?p=linux/kernel/git/arm/linux-arm-soc.git;a=shortlog;h=refs/heads/tmp/randconfig3
along with a lot of bug fixes for ARM. Feel free to play with that on
other architectures.

Since your patch adds another use of HAS_IOPORT, I will have to rename
that as well to HAS_IOPORT_MAP as I do for all the other uses.

	Arnd
