Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1FGLWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 07:22:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49893 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1FGLWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 07:22:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH/RFC] m68k/bitops: Make bitmap data pointer of atomic ops volatile
Date: Tue, 7 Jun 2011 13:22:29 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-m68k@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        linux-ide@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1307390873-29687-1-git-send-email-geert@linux-m68k.org> <201106062211.15247.arnd@arndb.de> <BANLkTin8XNA+ocdjUhtzVOQNxOGFsYa1mA@mail.gmail.com>
In-Reply-To: <BANLkTin8XNA+ocdjUhtzVOQNxOGFsYa1mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201106071322.29884.arnd@arndb.de>
X-Provags-ID: V02:K0:uDmFP+CWUIBXwc4Ynn7vgjbtEH67GR+w+6ZIoXDJ6tN
 3lNdDB6xPrNtgSZgvPLktZRYlSe2q4Ao4g9whBE52oBRyybcbE
 E5GXMyn3qtBpF0BKIcCjG0n6BSq+aPsgYYZU01DGy9k/Xx5Qqe
 GZ2Rv4D2aSETF3j+6p9m4s+l04imGFYkRlYpV2zGlTewOx2IHa
 +etptoPxP1h2NknjVFsCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 June 2011, Geert Uytterhoeven wrote:
> You mean the host_busy variable in the IDE code?
> That would also apply to context_flag in the DRM code:
> 
> drivers/gpu/drm/drm_context.c:233: warning: passing argument 2 of
> ‘__constant_test_and_set_bit’ discards qualifiers from pointer target
> type
> drivers/gpu/drm/drm_context.c:233: warning: passing argument 2 of
> ‘__generic_test_and_set_bit’ discards qualifiers from pointer target
> type

Yes, that fits the same category.

> > is wrong, though. It probably doesn't hurt to do both.
> 
> asm-generic/bitops/atomic.h has the volatiles everywhere. That's why
> I'm wondering.

I guess what happened is that some variables are traditionally marked
as volatile although they shouldn't be, and most architectures have
adapted their bitops to make the warnings go away. If you see more
warnings of that kind, it's probably fine to just do the same on m68k.
The volatile modifier doesn't really hurt in this case.

	Arnd
