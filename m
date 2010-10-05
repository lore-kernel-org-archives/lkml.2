Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab0JEGBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 02:01:17 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:60838 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab0JEGBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 02:01:16 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RESEND] [PATCH] Input: add appleir USB driver
Date: Tue, 5 Oct 2010 08:02:14 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Bastien Nocera <hadess@hadess.net>,
        "linux-input" <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1285844276.26405.26.camel@cookie.hadess.net> <201010042117.41786.oliver@neukum.org> <20101005044520.GA14707@core.coreip.homeip.net>
In-Reply-To: <20101005044520.GA14707@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010050802.14271.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 5. Oktober 2010, 06:45:20 schrieb Dmitry Torokhov:
> > > +{
> > > +   struct appleir *appleir = input_get_drvdata(dev);
> > > +
> > > +   mutex_lock(&appleir_mutex);
> > > +
> > > +   if (!(appleir->flags & APPLEIR_SUSPENDED)) {
> > > +           usb_kill_urb(appleir->urb);
> > > +           del_timer_sync(&appleir->key_up_timer);
> > 
> > You can close with a key unreleased.
> 
> I think this is handled by input core. We forcibly send release events
> when device is disconnected; this takes care of surprise disconnect case.
> OTOH if input_dev->close() is called that means that there are no more
> listeners for the events so the fact that a key is still pressed is not
> interesting to anyone.

But what about the next opener? He'll get a completely spurious
key release event, as the next key is pressed.

> > > +           usb_kill_urb(appleir->urb);
> > 
> > If the system goes to sleep you'd better report a pressed key
> > as released here and kill the timer.
> 
> Input core sends "release" events upon resume so we should be OK.

I see. OK, this is covered.

	Regards
		Oliver
