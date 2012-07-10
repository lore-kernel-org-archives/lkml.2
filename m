Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab2GJQw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:52:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53941 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab2GJQwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:52:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Date: Tue, 10 Jul 2012 16:52:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <20120710101018.GE15120@arm.com> <20120710163358.6ae4a576@pyramind.ukuu.org.uk>
In-Reply-To: <20120710163358.6ae4a576@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207101652.18401.arnd@arndb.de>
X-Provags-ID: V02:K0:zC+smSJN+sEfLmZMtf3ktPDZMECmiqDx9U5mmnGnoFJ
 szk5W2Some8TDGpyyi/8oQen9eCtV1tcX1x6cgYRNkCujqkC/W
 SK+33zV1juALFBUDOXpbgAq6dRLz2Phl+VJ2MzSmNIaPcNWSjv
 Fug4XPVPDL/YFYMi8K0ed6FYokjnsMAOEblgzFDdXtOojMVtAG
 cNSxaPgmmH102c2UzRZOwU4TfD9YVRpCqARJdR3DBzO6WdGvJX
 inMY6YkXPvBxt5mStkV40/eVDgcGmYMwQR7r3JAm7YZYHvw1Jc
 MoE1P6qQ2maNMd4aKUJ/hBAH/X8xHWGFS+SMsYaiZSiZVKag7Y
 HbnE3eGq7PUlaXAKyfjs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2012, Alan Cox wrote:
> > In the AArch32 kernel port many implementation decisions newer
> > architectures were made in a way that preserves backwards compatibility
> > to over 15 years ago (and for good reasons, ARMv4 hardware is still in
> > use). But keeping the same decisions in AArch64 is wrong.
> 
> Same argument as x86-32 v x86-64. Same issues about compatibility.

Similar but not the same. In case of x86-64 the hardware was actually
meant to run old 32 bit kernel binaries and still can. I don't
expect to see any 64 bit ARM systems running 32 bit kernels, and
I will almost certainly reject any attempt to submit such a platform
support to the arm-soc tree.

Another difference is the amount of legacy code for 32 bit ARM, which
no other architecture comes close to. With AArch64 we really want to
do a lot of things in a more modern way, and doing in in a common tree
would mean having to change a lot of old code at once. We might get
there eventually, but I would not want to depend on it.

> > The initial target is servers (see the companies that have announced
> > plans around ARMv8) but I agree, we may see it in other devices in the
> > future. But as the maintainer I have no plans to support a 32-bit SoC on
> > an AArch64/ARMv8 system (which may or may not support AArch32 at kernel
> > level). If an AArch64 SoC would share some devices with an AArch32 SoC,
> > such code will go to drivers/.
> 
> What plans to other maintainers and board vendors have ? Any design choice
> has to cope with these happening if a third party goes and does it.

It is slightly worrying to have multiple SoC vendors working on their
own platform support. There are a few things we can assume though:

* Everyone who has an AArch64 implementation has access to Catalin's
kernel patches in is basing their stuff on top of it.

* Most likely they are all working on server chips, which means they
want to have their hardware supported in upstream kernels and
enterprise distros.

* Unlike on 32 bit, the different platforms cannot be compile-time
exclusive. A platform port that cannot be enabled without breaking
another platform is not getting merged.

* I do not expect board-specific kernel patches, at least no more
than we have them on x86 with the occasional hack to work around
a broken machine.

* The differences between SoCs will be confined to device drivers
to a much larger degree than they are on 32 bit, partly because
the SoC companies are trying to be fit into the single-kernel
model, and partly because we have added the infrastructure to
allow it.

	Arnd
