Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2C1LTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:19:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35127 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab2C1LTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:19:53 -0400
Date: Wed, 28 Mar 2012 13:19:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Trevor Turner <turn3r.tr3v0r@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: K7/Athlon Optimization Causes Build Fail on Kernel 3.3 i686
Message-ID: <20120328111957.GA6765@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Trevor Turner <turn3r.tr3v0r@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CANYHJ6jjuO7yV_kbPsnJ6X+KXrsz2PRPPXHN4Rkr-vgoSG-E4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANYHJ6jjuO7yV_kbPsnJ6X+KXrsz2PRPPXHN4Rkr-vgoSG-E4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 06:56:51AM -0700, Trevor Turner wrote:
> Hi,
> The other day when I was compiling 3.3 on my home server, enabling the
> K7/Athlon family optimizations seems to cause the build to fail.

I'm assuming with this you mean

CONFIG_MK7, i.e. "Athlon/Duron/K7" in "Processor Family" under
"Processor Type and Features" in the kernel configurator? At least it
looks like this from your other mail with the failing .config.

> It fails without any erroneous output at the very end of the build and
> has been reproducible every time I've built with it enabled. This
> machine has a pair of Athlon 2000+ MP's and I'm using Arch Linux's
> makepkg system (which calls make localmodconfig, make nconfig, and
> make -j3 bzImage modules) to build my kernels. I have experienced
> this issue on both the stock -ARCH kernel, and the -CK kernel under a
> number of different configurations.

Right, can you try this with the upstream kernel, i.e.

1. get one from kernel.org
2. copy the .config into the directory where you've unpacked the sources
3. do 'make oldconfig' and then 'make menuconfig' and go and select Athlon build
4. do 'make -j3 > w.log 2>&1' so that you can catch the build output into w.log
which you can send later

Also, which build tools are you using, simply do

./scripts/ver_linux

in the kernel source directory, catch the output and send it on pls.

This should be all for now, thanks.

-- 
Regards/Gruss,
Boris.
