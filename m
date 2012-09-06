Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab2IFLRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:17:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41988 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2IFLRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:17:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120906103248.GA36903@macbook.local>
References: <20120824051016.GB1718@vandijck-laurijssen.be>
	<50376550.4020501@pengutronix.de>
	<20120824124248.GA422@vandijck-laurijssen.be>
	<20120824220142.GA1470@gmail.com>
	<5044A547.2010603@pengutronix.de>
	<20120903181335.GA415@vandijck-laurijssen.be>
	<20120903182925.GA28766@gmail.com>
	<50451919.20205@hartkopp.net>
	<20120904071128.GB416@vandijck-laurijssen.be>
	<20120904201553.GA29478@gmail.com>
	<20120906103248.GA36903@macbook.local>
Date: Thu, 6 Sep 2012 13:17:39 +0200
X-Google-Sender-Auth: h_pyDETZIT1WB6DqXDv1A1gmeXU
Message-ID: <CABkP77fff7wmZKbT=xbcBkSgLTbjTTzxOpQsWLrHTeG-53KSWQ@mail.gmail.com>
Subject: Re: [PATCH can-next v6] can: add tx/rx LED trigger support
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Fabio Baltieri <fabio.baltieri@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kurt,

On Thu, Sep 6, 2012 at 12:33 PM, Kurt Van Dijck <kurt.van.dijck@eia.be> wrote:
> On Tue, Sep 04, 2012 at 10:15:53PM +0200, Fabio Baltieri wrote:
>> On Tue, Sep 04, 2012 at 09:11:28AM +0200, Kurt Van Dijck wrote:
> [...]
>> > > The name of the device can only be changed when the interface is down.
>> > > Is it possible to put some scripting around it to detach and attach the leds
>> > > to the interfaces on ifup/ifdown triggers?
>> >
>> > Are the led triggers available for using while the netdev is down then?
>>
>> Sure!  On embedded systems triggers are usually attached to actual LEDs
>> at probe time using default_trigger field of struct led_classdev, and
>> that can be specified both in machine files or in device tree.
>
> I also think that led triggers should be available.

Right, that's why I think the only way is to use device name.

> I asked the question because detach & attach leds to interfaces would
> indeed break that.

Sure? I think that the trigger would be set again on reattach, as
default_trigger is checked both in led_cdev probe and
trigger_register, see:

http://lxr.free-electrons.com/source/drivers/leds/led-triggers.c#L180

I'll try that tonight.

> btw, I tried to send a patch tuesday (my first $ git send-email) using
> netdev notifiers: did you receive it, and what do you think of it?

Sure, I got it!  I was planning to try that this weekend but I can
give you some comments earlier tonight... sorry for the dealy!

Fabio

-- 
Fabio Baltieri
