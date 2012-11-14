Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab2KNIaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:30:21 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56897 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab2KNIaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:30:19 -0500
Date: Wed, 14 Nov 2012 09:30:13 +0100
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>
Subject: Re: [PATCH v2 RESEND] leds: add led_trigger_rename function
Message-ID: <20121114083013.GA23881@gmail.com>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@gmail.com>,
	Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
	Kurt Van Dijck <kurt.van.dijck@eia.be>
References: <1352022874-5100-1-git-send-email-fabio.baltieri@gmail.com>
 <CAK5ve-Jn_1Lc=FyX24_DHDz6+=VUC5xoiH4zUWLgRB=rgOiueA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-Jn_1Lc=FyX24_DHDz6+=VUC5xoiH4zUWLgRB=rgOiueA@mail.gmail.com>
X-Operating-System: Linux balto 3.7.0-rc3-00218-g45a82fc x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Tue, Nov 13, 2012 at 04:33:14PM -0800, Bryan Wu wrote:
> > +void led_trigger_rename_static(const char *name, struct led_trigger *trig)
> > +{
> > +       /* new name must be on a temporary string to prevent races */
> > +       BUG_ON(name == trig->name);
> > +
> > +       down_write(&triggers_list_lock);
> > +       /* this assumes that trig->name was originaly allocated to
> > +        * non constant storage */
> > +       strcpy((char *)trig->name, name);
> 
> Is this strcpy() safe here? Probably strncpy() or strlcpy() is safer.

Actually the LED subsystem is not aware of the string allocation size,
so I guess that strcpy is the only option here.

On the other side, the caller, who originally allocated the string,
should do the check properly, such as in:

	snprintf(name, sizeof(name), "%s-tx", netdev->name);
	led_trigger_rename_static(name, priv->tx_led_trig);

> > +extern void led_trigger_rename_static(const char *name,
> > +                                     struct led_trigger *trig);
> > +
> 
> Any example how to use this new API?

Sure!  That was developed as part of CANBUS LED triggers to have trigger
name follow can interfaces name changes.

Original patch using this function, including the whole discussion
behind it, was posted here:

https://lkml.org/lkml/2012/9/10/544

or you can find the complete set on my github branch:

http://github.com/fabiobaltieri/linux.git can-leds-devel

Fabio

-- 
Fabio Baltieri
