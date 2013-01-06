Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab3AFCWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 21:22:35 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:54160 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab3AFCWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 21:22:32 -0500
Date: Sat, 5 Jan 2013 18:19:01 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        anish kumar <anish198519851985@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH] EXTCON: Get and set cable properties
Message-ID: <20130106021901.GB15410@lizard.sbx05280.losalca.wayport.net>
References: <1354052956-3394-1-git-send-email-jenny.tc@intel.com>
 <20ADAB092842284E95860F279283C564E2754F@BGSMSX101.gar.corp.intel.com>
 <20121203012916.GA7330@lizard.sbx05977.paloaca.wayport.net>
 <20ADAB092842284E95860F279283C564E293C9@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20ADAB092842284E95860F279283C564E293C9@BGSMSX101.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 02:09:02AM +0000, Tc, Jenny wrote:
> > > Could you please review this. This is a follow up patch for "PATCH]
> > > extcon : callback function to read cable property"
> > 
> > While I see nothing wrong with the patch itself, I beg you to send some users
> > for the new calls. Don't be obsessed with the extcon internals too much,
> > think more about how things will interact (i.e. I really really want to see how
> > you use these calls from the power supply drivers).
> 
> The usage of extcon cable property is captured in patch https://lkml.org/lkml/2012/10/18/219
> This patch uses a extcon_dev  callback function get_cable_properties() to get the
> cable properties. As discussed in the previous mail thread, it may not be good to have a extcon call
> back function since the extcon provider may not be aware of the cable properties. This patch replaces
> the callback function with an API, so that whoever knows the cable property, can set the property
> using the extcon API extcon_cable_set_data().
> 
> The usage flow would be
> 1)Consumer gets a notification from the extcon
> 2)consumer reads the property using the API extcon_cable_get_data
> 
> This way it doesn't mandatory for the extcon provider to give the cable property.
> Anyone who is aware of the cable property can set the cable property using the API.
> It makes the consumer and provider implementations very simple.
> 
> With this new API, the callback function in patch https://lkml.org/lkml/2012/10/18/219 can be
> replaced by the API extcon_cable_set_data().

Looking at this, the whole idea of hiding power source behind the "extcon"
seems dubious. Why don't you use USB device to get the current?

"extcon" subsystem, as I see it, should only be used to get notified about
external connectors events. And that's all. And chargers probably should
not even care about extcon (well, with the exception of the direct AC/gpio
power source).

For USB, it would make more sense if for you'd get plug/unplug
notifications *and* properties from the USB device (or OTG transceiver)
directly, not from the extcon. And I guess we have this mechanism already,
see drivers/power/pda_power.c.

Thanks,
Anton
