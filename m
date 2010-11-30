Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab0K3QTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:19:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49922 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0K3QTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:19:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI Bus
Date: Tue, 30 Nov 2010 17:19:02 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        linux-arm-kernel@lists.infradead.org,
        =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>,
        linux-kernel@vger.kernel.org
References: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com> <201011291657.53316.arnd@arndb.de> <20101130160527.GB2377@n2100.arm.linux.org.uk>
In-Reply-To: <20101130160527.GB2377@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011301719.03202.arnd@arndb.de>
X-Provags-ID: V02:K0:q4G7o5stKpbR/VWmAWawf6xf8e4Wcp3C++o3QTTPviY
 1AP7jrNhawZdCivJgGCtiKgPeynEqnQ4qWaKSLe5F74ARjwuZ/
 0RoNACZgaSs6E9kXZ+qLZ0xOeXFyL3F2ZY1euyy1EoE+zCrE+Y
 aHctvnDb6rC+pOEBy3JPU146vACltihyGmlqPYc0kB6ZlwpXdT
 gF7cikQ9q5PBzVytY1NUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 November 2010, Russell King - ARM Linux wrote:
> No, the above is correct.  What I was talking about was the difference
> between these:
> 
> config PCI
>         bool "PCI support" if MIGHT_HAVE_PCI
> 
> and
> 
> config PCI
>         bool "PCI support"
>         depends on MIGHT_HAVE_PCI
> 
> In the first instance, PCI itself does not depend on MIGHT_HAVE_PCI.
> MIGHT_HAVE_PCI controls whether the user is offered the "PCI support"
> option.
> 
> In the second instance, PCI depends on MIGHT_HAVE_PCI, which must be
> set to 'y' to offer the option and also if PCI is selected.

Right, I misread the patch as doing the wrong thing, thanks for
clearing that up.

> We want the first behaviour.  Platforms which must have PCI support can
> continue to select PCI as they currently do, and leave the MIGHT_HAVE_PCI
> option alone.
> 
> Platforms which may optionally have PCI support should select
> MIGHT_HAVE_PCI instead.

Yes, that sounds good.

	Arnd
