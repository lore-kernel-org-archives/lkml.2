Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967152Ab2EPNGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:06:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51972 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958Ab2EPNG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:06:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the staging tree
Date: Wed, 16 May 2012 13:03:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
References: <20120516185812.ce1ab57c3ec72445135a35fc@canb.auug.org.au> <201205161054.15610.arnd@arndb.de> <20120516124851.GA32064@kroah.com>
In-Reply-To: <20120516124851.GA32064@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205161303.35080.arnd@arndb.de>
X-Provags-ID: V02:K0:xoxFDlnDsemApxS7VJLlvfGLzqH78oBT3CVRXmg8og3
 dQh295gZTHVZPDyTfHFPZwzSTzJGRYQW3UGZRc2ZZVNjRZNzlW
 xUezm9s67HP6YKKZNzU1cgo99gprNG7dv+PI4XT57eexsZGA3h
 7Ou0eqXk8cy3FuYYlhiPX2gDKVfcSW1zTm+o0k+8DTQwdMasMJ
 xPjF26jMDPktgZomsJ3ICCCmLSk58VO66v+RNr1lb76vbUIAG/
 gCQs6EKRvaOguT4iEOpmERYTKmTBHxFRA5D0QXOAjLNyyu6lLY
 t7wmq/NItXYEPJGXJcjfv1eo9XgCKH3f2BveUiRO0MPQFjFov7
 Yzm0JDVWbzcDV3kQYJzI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2012, Greg KH wrote:
> On Wed, May 16, 2012 at 10:54:15AM +0000, Arnd Bergmann wrote:
> > On Wednesday 16 May 2012, Stephen Rothwell wrote:
> > > Today's linux-next merge of the arm-soc tree got a conflict in
> > > arch/arm/boot/dts/at91sam9g20.dtsi between commit 7cb2e629a240 ("ARM:
> > > AT91: Add ADC driver to the at91sam9g20 dtsi") from the staging tree and
> > > commit 5b6089cb6f28 ("ARM: at91: add at91sam9260 DT support") from the
> > > arm-soc tree.
> > > 
> > > So, I didn't know what to do with this, so I used the arm-soc version of
> > > this file (effectively throwing away the staging tree change).  Hints,
> > > anyone?
> > 
> > I suspect the addition of the adc node should just go into the
> > at91sam9260.dtsi file.
> 
> So does that mean that the staging tree version is correct?  Or that
> someone needs to send me a fixup patch here?

The staging tree version adds contents to at91sam9g20.dtsi, and the context
gets moved to at91sam9260.dtsi in arm-soc. If we want to resolve it now,
I think the best way is to add the change to at91sam9260.dtsi in arm-soc
and let you drop that part in staging. There are no hard dependencies
since this is new code and it the driver is still correct without the
change, it simply won't find the device.

	Arnd
