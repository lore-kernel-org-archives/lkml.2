Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2DUGA7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 02:00:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37399 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2DUGA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 02:00:58 -0400
Date: Fri, 20 Apr 2012 23:00:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Daniel Drake <dsd@laptop.org>, Peter Hutterer <peter.hutterer@who-t.net>,
        "X.Org Devel List" <xorg-devel@lists.freedesktop.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Multitouch regression in 3.3 on thinkpad X220 clickpad
Message-ID: <20120421060052.GB27551@core.coreip.homeip.net>
References: <1334906476.3197.11.camel@pasglop>
 <CAMLZHHTpNPbbMwrNmZf5Japk2b3gNZ7eAhU5xoG+a1jEPk96ig@mail.gmail.com>
 <20120420170132.GA32261@core.coreip.homeip.net>
 <1334967400.3312.4.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334967400.3312.4.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 10:16:40AM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2012-04-20 at 10:01 -0700, Dmitry Torokhov wrote:
> 
> > It looks we lost a condition in synaptics_set_advanced_gesture_mode().
> > It used to be:
> > 
> > 
> > 	if (!(SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) ||
> > 			SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)))
> > 		return 0;
> > 
> > and now simply is:
> > 
> > 	if (!SYN_CAP_ADV_GESTURE(priv->ext_cap_0c))
> > 		return 0;
> > 
> > Could you try restoring the condition and see if it fixes the
> > regression?
> 
> Yes, that's it. Please shoot the patch below to Linus.
> 
> Thanks,
> Ben.
> 
> input/synaptics: Fix regression with "image sensor" trackpads
> 
> commit 7968a5dd492ccc38345013e534ad4c8d6eb60ed1
> Input: synaptics - add support for Relative mode
> 
> Accidentally broke support for advanced gestures (multitouch)
> on some trackpads such as the one in my ThinkPad X220 by
> incorretly changing the condition for enabling them. This
> restores it.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: stable@kernel.org [3.3]
> 

Applied, thank you Ben.

-- 
Dmitry
