Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab1KQLV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:21:27 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:2186 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365Ab1KQLVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:21:25 -0500
From: <oskar.andero@sonyericsson.com>
Date: Thu, 17 Nov 2011 12:22:19 +0100
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "aghayal@codeaurora.org" <aghayal@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonyericsson.com>,
        Shubhrajyoti <shubhrajyoti@ti.com>
Subject: Re: [PATCH v3] input: add driver support for Sharp gp2ap002a00f
 proximity sensor
Message-ID: <20111117112219.GA14781@caracas.corpusers.net>
References: <1321349160-2931-1-git-send-email-oskar.andero@sonyericsson.com>
 <20111115094342.GD13157@core.coreip.homeip.net>
 <20111115125352.GA23767@caracas.corpusers.net>
 <20111115182909.GB6410@core.coreip.homeip.net>
 <20111116103705.GA14696@caracas.corpusers.net>
 <4EC39E7B.7020706@ti.com>
 <20111116121803.GB14696@caracas.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111116121803.GB14696@caracas.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 13:18 Wed 16 Nov     , Oskar Andero wrote:
> On 12:28 Wed 16 Nov     , Shubhrajyoti wrote:
> > On Wednesday 16 November 2011 04:07 PM, oskar.andero@sonyericsson.com
> > wrote:
> > > On 19:29 Tue 15 Nov     , Dmitry Torokhov wrote:
> > >> On Tue, Nov 15, 2011 at 01:53:52PM +0100, oskar.andero@sonyericsson.com wrote:
> > >>> On 10:43 Tue 15 Nov     , Dmitry Torokhov wrote:
> > >>>> On Tue, Nov 15, 2011 at 10:26:00AM +0100, oskar.andero@sonyericsson.com wrote:
> > >>>>> From: Courtney Cavin <courtney.cavin@sonyericsson.com>
> > >>>>> +
> > >>>>> +#ifdef CONFIG_PM_SLEEP
> > >>>>> +static int gp2a_suspend(struct device *dev)
> > >>>>> +{
> > >>>>> +	struct i2c_client *client = to_i2c_client(dev);
> > >>>>> +	struct gp2a_data *dt = i2c_get_clientdata(client);
> > >>>>> +	int error;
> > >>>>> +
> > >>>>> +	mutex_lock(&dt->device->mutex);
> > >>>>> +
> > >>>>> +	if (dt->device->users) {
> > >>>>> +		if (device_may_wakeup(&client->dev)) {
> > >>>>> +			enable_irq_wake(client->irq);
> > >>>> I think this part should happen regardless of whether device has users,
> > >>>> only non wakeup source case needs it.
> > >>> Hmm.. why would one want to enable irq_wake when there are no users?
> > >>> Wouldn't this cause the device to wakeup at every irq and report an
> > >>> switch event that no one listens to?
> > >> You are suspending the system and want to have this device as a wakeup
> > >> source. Note: not wake up _device_ at every IRQ but wake up the whole
> > >> _system_ when device generates an IRQ while system is asleep.
> > >> It does not matter whether there are users for the events; you
> > >> want the system to wake up.
> > >>
> > >> At least this is the usual semantics.
> > > I see you point. However, the way we use the proximity sensor we can only wake up
> > > the system when we have an application that is actually interested in the change.
> > > This is for power save reasons.
> > > If we use the "usual semantic", we would wake up the system at every proximity
> > > detection regardlessly. For instance, I wouldn't want to wake up a cell phone laying
> > > on the desk when I put my hand over it. That would hurt the battery time.
> > Even in that case it shouldn't harm the power if no user is there the
> > close would have been called
> > and you should  be in the shut down mode? Am I missing something?
> 
> You are right - the chip will only generate interrupts when it's opened, so the case
> I described shouldn't actually be a problem. However, does it make sense to enable irq_wake
> for a device that will never generate interrupts?

Do you have any input on my question above? My suggestion is to keep the code as it is,
unless you see a reason for enabling wake_irq on an irq that will never happen.

I'll prepare v4 as soon as I have your answer.

Thanks!

-Oskar
