Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab1BQBFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:05:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51441 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab1BQBFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:05:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BXVvGGg0iMxmaRgQBhCGzazwu/IhG7LXunUv6FbuVDj5ryh9fdXQz2ELt81baFFHit
         agopkHoc4wh+6HilkwLThxUrwozOUmgGLYk+/QHKT7prT8dyjpcJvv6zAf12a1HK5G5w
         hhgWfAH4Brmx7efRns+enPPEDAHzKwDUMxvQo=
Date: Wed, 16 Feb 2011 17:05:12 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Frederick van der Wyck <fvanderwyck@gmail.com>, mjg@redhat.com,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Platform: Samsung Q10 backlight driver
Message-ID: <20110217010511.GB16004@core.coreip.homeip.net>
References: <20110216233029.GB17288@ntl>
 <20110216235807.GA6210@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216235807.GA6210@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 03:58:07PM -0800, Greg KH wrote:
> On Wed, Feb 16, 2011 at 11:30:29PM +0000, Frederick van der Wyck wrote:
> > +
> > +static void samsungq10_bl_send_intensity(struct backlight_device *bd)
> > +{
> > +	int brightness = bd->props.brightness;
> > +
> > +	if (!samsungq10_suspended) {
> > +		while (inb(0x64)&2)
> > +			;
> > +		outb_p(0xbe, 0x64);
> > +		while (inb(0x64)&2)
> > +			;
> > +		outb_p(0x89, 0x60);
> > +		while (inb(0x64)&2)
> > +			;
> > +		outb_p(0x91, 0x60);
> > +		while (inb(0x64)&2)
> > +			;
> 
> Potentially endless loops are not good, please timeout if you don't get
> the proper value over a time.

Double not good since it is i8042 registers. Use
i8042_lock_chip()/i8042_command()/i8042_unlock_chip().

-- 
Dmitry
