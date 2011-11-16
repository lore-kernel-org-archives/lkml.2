Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab1KPKgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 05:36:16 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:7185 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755394Ab1KPKgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 05:36:14 -0500
From: <oskar.andero@sonyericsson.com>
Date: Wed, 16 Nov 2011 11:37:06 +0100
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "aghayal@codeaurora.org" <aghayal@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonyericsson.com>
Subject: Re: [PATCH v3] input: add driver support for Sharp gp2ap002a00f
 proximity sensor
Message-ID: <20111116103705.GA14696@caracas.corpusers.net>
References: <1321349160-2931-1-git-send-email-oskar.andero@sonyericsson.com>
 <20111115094342.GD13157@core.coreip.homeip.net>
 <20111115125352.GA23767@caracas.corpusers.net>
 <20111115182909.GB6410@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111115182909.GB6410@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:29 Tue 15 Nov     , Dmitry Torokhov wrote:
> On Tue, Nov 15, 2011 at 01:53:52PM +0100, oskar.andero@sonyericsson.com wrote:
> > On 10:43 Tue 15 Nov     , Dmitry Torokhov wrote:
> > > On Tue, Nov 15, 2011 at 10:26:00AM +0100, oskar.andero@sonyericsson.com wrote:
> > > > From: Courtney Cavin <courtney.cavin@sonyericsson.com>
> > > > +
> > > > +#ifdef CONFIG_PM_SLEEP
> > > > +static int gp2a_suspend(struct device *dev)
> > > > +{
> > > > +	struct i2c_client *client = to_i2c_client(dev);
> > > > +	struct gp2a_data *dt = i2c_get_clientdata(client);
> > > > +	int error;
> > > > +
> > > > +	mutex_lock(&dt->device->mutex);
> > > > +
> > > > +	if (dt->device->users) {
> > > > +		if (device_may_wakeup(&client->dev)) {
> > > > +			enable_irq_wake(client->irq);
> > > 
> > > I think this part should happen regardless of whether device has users,
> > > only non wakeup source case needs it.
> > 
> > Hmm.. why would one want to enable irq_wake when there are no users?
> > Wouldn't this cause the device to wakeup at every irq and report an
> > switch event that no one listens to?
> 
> You are suspending the system and want to have this device as a wakeup
> source. Note: not wake up _device_ at every IRQ but wake up the whole
> _system_ when device generates an IRQ while system is asleep.
> It does not matter whether there are users for the events; you
> want the system to wake up.
> 
> At least this is the usual semantics.

I see you point. However, the way we use the proximity sensor we can only wake up
the system when we have an application that is actually interested in the change.
This is for power save reasons.
If we use the "usual semantic", we would wake up the system at every proximity
detection regardlessly. For instance, I wouldn't want to wake up a cell phone laying
on the desk when I put my hand over it. That would hurt the battery time.

-Oskar
