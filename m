Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0DLQ4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 12:56:18 -0400
Received: from legolas.restena.lu ([158.64.1.34]:47652 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab0DLQ4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 12:56:16 -0400
Date: Mon, 12 Apr 2010 18:56:07 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH v6 7/8, needs improvement] hid: add suspend/resume hooks
 for hid drivers
Message-ID: <20100412185607.10c7b3be@neptune.home>
In-Reply-To: <alpine.LNX.2.00.1004121342550.8345@pobox.suse.cz>
References: <20100324233707.7243b04d@neptune.home>
	<20100324234022.0361bd80@neptune.home>
	<20100326065656.GC26602@core.coreip.homeip.net>
	<20100326102951.3b9ecda1@neptune.home>
	<alpine.LNX.2.00.1003262156280.24576@pobox.suse.cz>
	<20100327012245.0ace6a09@neptune.home>
	<alpine.LNX.2.00.1003291144350.24576@pobox.suse.cz>
	<20100329121611.0c22dcaf@pluto.restena.lu>
	<alpine.LNX.2.00.1003301010410.24576@pobox.suse.cz>
	<20100330223224.18fe4f3e@neptune.home>
	<20100330224230.7b84df75@neptune.home>
	<alpine.LNX.2.00.1003311415000.24576@pobox.suse.cz>
	<20100411130226.4086a92d@neptune.home>
	<alpine.LNX.2.00.1004112029220.8345@pobox.suse.cz>
	<20100411204002.6ba32f43@neptune.home>
	<alpine.LNX.2.00.1004121342550.8345@pobox.suse.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 April 2010 Jiri Kosina <jkosina@suse.cz> wrote:
> On Sun, 11 Apr 2010, Bruno Prémont wrote:
> 
> > > > As far as I understand the code, in auto-suspend case if the driver 
> > > > sends commands to the device it will have to call usbhid_wait_io(). 
> > > > Please correct me if I'm wrong!
> > > 
> > > It's not needed. There is a queuing mechanism in place on 
> > > 'resumption_waker' workqueue.
> > 
> > So the driver is not allowed to ask the device to do something
> > at auto-suspend time (as that would abort the auto-suspension).
> 
> What do you mean by "is not allowed" exactly?
>
> Yes, it will wake the device up from auto-suspension. However, that's 
> usually what you want to happen, is there is anything you need to dispatch 
> to the device, isn't it?

I thought of a report to send to device to ask the device to disable some
power using feature (e.g. turning off or dimming LEDs)

> What exactly is the situation you are trying to handle?

That's rather a generic question, not related to any implementation.

Maybe I'm mixing suspend and USB-autosuspend too much?

Thanks,
Bruno
