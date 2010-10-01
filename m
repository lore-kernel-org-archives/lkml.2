Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab0JAW2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 18:28:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:55199 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab0JAW2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 18:28:21 -0400
Subject: Re: Introduce support for little endian PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Olof Johansson <olof@lixom.net>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@lists.ozlabs.org,
        paulus@samba.org, Ian Munsie <imunsie@au1.ibm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101001220343.GA10494@lixom.net>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	 <2C5357FA-F87F-457E-B5C1-0DCC5A842DE7@kernel.crashing.org>
	 <AANLkTinSDMvBb7rnnfwYMkEVOgDUqRetZg86rh-UmSAg@mail.gmail.com>
	 <1285935283.2463.78.camel@pasglop>
	 <BBD78246-343E-4A96-9E55-3E40AD628C0B@kernel.crashing.org>
	 <1285966315.2463.141.camel@pasglop>  <20101001220343.GA10494@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Oct 2010 08:28:02 +1000
Message-ID: <1285972082.2463.250.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 17:03 -0500, Olof Johansson wrote:
> > Maybe. Most of it doesn't seem to be that bit-rottable.
> > 
> > The changes to the asm stuff in misc_32.S for example are functions we
> > never ever touch once written (libgcc replacements) so I don't see them
> > rotting more with LE support than they did with BE :-)
> 
> Does KVM/qemu support running LE guest on BE host? That'd help keeping
> the bitrot lower. :) 

Not yet I suppose :-) But then, I'm not sure it would make a big
difference, if you have a 440 board in the first place, you can boot
either LE or BE, no need for a special FW or anything.

What we've done is basically keep the zImage wrapper BE (for now at
least), and have it trampoline to LE when executing the actual kernel
(using a cuImage, of course a device-tree enabled u-Boot would probably
need something akin to a proper ePAPR zImage to do that but that's
reasonably easy to do nowadays).


Cheers,
Ben.


