Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab0LHWUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:20:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35271 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab0LHWUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:20:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mSF2ftcVRGQRu9fCKiUxHJnkEujH1XURmxfQa53/iTimCS5efQ1/+CB21NHrAvqfmB
         K1uhjEcqbvJu/25Q0CsSShBMaj0HmEgSG4RTpbG6XcXo7adHMZYU/D9Piwnq2t3r9BNe
         65m5yywjof1d+bOS7OGJ7I7RLr+Y5RK4NI0oA=
Date: Wed, 8 Dec 2010 14:12:17 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>, sedat.dilek@gmail.com,
        Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for December 8
 (drivers/platform/x86/Kconfig:422:error: recursive dependency detected!)
Message-ID: <20101208221216.GA5649@core.coreip.homeip.net>
References: <AANLkTim3FJjVpbjM10kJJhXbONpvGSGQFE+mfGX9pAS6@mail.gmail.com>
 <AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com>
 <1291801990.5992.105.camel@i7.infradead.org>
 <20101208174603.GA7107@core.coreip.homeip.net>
 <20101208135105.a8482d46.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101208135105.a8482d46.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 01:51:05PM -0800, Randy Dunlap wrote:
> On Wed, 8 Dec 2010 09:46:04 -0800 Dmitry Torokhov wrote:
> 
> > On Wed, Dec 08, 2010 at 09:53:09AM +0000, David Woodhouse wrote:
> > > On Wed, 2010-12-08 at 10:12 +0100, Corentin Chary wrote:
> > > > 
> > > > I don't really see how it's a recursive dependency, but maybe it's
> > > > time to clean this KConfig.
> > > > What is our current policy about that ?
> > > > 
> > > > I think we should *depends* on important subsystem (ACPI, INPUT, ...)
> > > > and select obscure things so
> > > > that the driver does not get lost if you don't enable the leds.
> > > 
> > > A better policy is: "NEVER USE SELECT".
> > > 
> > 
> > No, this is BS. User selecting, for example, a button driver should not
> > care that it is working in polling mode only and needs polled device
> > library to work. As it was said before, drivers need to depend on major
> > subsystems and select minors and library modules.
> 
> I dislike select, but reality is that modules do need to select/enable
> library code and minor features sometimes.
> 
> OTOH, where drivers/platform/x86/Kconfig:ACPI_CMPC does "select INPUT"
> to enable an entire subsystem is wrong and bad IMO.

I am 50/50 here. On one hand selecting whole subsystems may not be the
best option, on the other hand (depending on how Kconfig is organized)
it might make sense. Consider you have an USB joystick. You are in
input, in joystick sub-menu, which comes _before_ USB. If you happen to
have USB disabled then you, with your scheme, will not see the entry for
the joystick. You will have to go into USB menu, activate USB and then
go back and scan menus that you already been to for any new options. And
again, and again. Not very friendly and so right now USB input devices
do depend on INPUT, select USB and depend on USB_ARCH_HAS_HCD (to make
sure USB can be activated).

Also, in case of CMPC, the user wants to support _all_ features of
his/her laptop which is kind of useless without input, right?

-- 
Dmitry
