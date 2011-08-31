Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab1HaUBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 16:01:12 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:50939 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab1HaUBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 16:01:09 -0400
Date: Wed, 31 Aug 2011 16:01:05 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, x86@kernel.org,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 3/4] platform: (TS-5500) add LED support
Message-ID: <20110831160105.27fe89fd@v0nbox>
In-Reply-To: <4E5D5E50.2080809@zytor.com>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1314402027-11293-4-git-send-email-vivien.didelot@savoirfairelinux.com>
	<20110829221654.GD26846@sirena.org.uk>
	<4E5C7731.3080309@zytor.com>
	<20110830171424.71465472@v0nbox>
	<20110830211528.GU2061@opensource.wolfsonmicro.com>
	<4E5D535B.3050304@zytor.com>
	<20110830175644.2ff5d086@v0nbox>
	<4E5D5E50.2080809@zytor.com>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 15:04:00 -0700,
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 08/30/2011 02:56 PM, Vivien Didelot wrote:
> >>
> > I wrote the led_set function like:
> > 
> >   static void ts5500_led_set(struct led_classdev *led_cdev,
> >                              enum led_brightness value)
> >   {
> >           struct ts5500_led *led = container_of(led_cdev,
> >                                                 struct ts5500_led,
> >                                                 cdev);
> >           mutex_lock(&led->lock);
> >           led->new_brightness = (value == LED_OFF) ? LED_OFF :
> > LED_FULL; outb(value, led->ioaddr);
> >           mutex_unlock(&led->lock);
> >   }
> > 
> > I guess the wrong value could be read if we get preempted just
> > before the outb() call, am I wrong?
> > 
> 
> And what happens if we do?
> 
> P.S. Your canonicalization of the value doesn't extend to outb().
> 
> 	-hpa

In fact the new_brightness field wasn't necessary in this driver, so I
removed it and now the function only contains the outb() call. Thanks.

	Vivien
