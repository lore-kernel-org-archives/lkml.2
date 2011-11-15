Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab1KOS3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 13:29:21 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56951 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab1KOS3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 13:29:19 -0500
Date: Tue, 15 Nov 2011 10:29:10 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: oskar.andero@sonyericsson.com
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "aghayal@codeaurora.org" <aghayal@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonyericsson.com>
Subject: Re: [PATCH v3] input: add driver support for Sharp gp2ap002a00f
 proximity sensor
Message-ID: <20111115182909.GB6410@core.coreip.homeip.net>
References: <1321349160-2931-1-git-send-email-oskar.andero@sonyericsson.com>
 <20111115094342.GD13157@core.coreip.homeip.net>
 <20111115125352.GA23767@caracas.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115125352.GA23767@caracas.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 01:53:52PM +0100, oskar.andero@sonyericsson.com wrote:
> On 10:43 Tue 15 Nov     , Dmitry Torokhov wrote:
> > On Tue, Nov 15, 2011 at 10:26:00AM +0100, oskar.andero@sonyericsson.com wrote:
> > > From: Courtney Cavin <courtney.cavin@sonyericsson.com>
> > > +
> > > +#ifdef CONFIG_PM_SLEEP
> > > +static int gp2a_suspend(struct device *dev)
> > > +{
> > > +	struct i2c_client *client = to_i2c_client(dev);
> > > +	struct gp2a_data *dt = i2c_get_clientdata(client);
> > > +	int error;
> > > +
> > > +	mutex_lock(&dt->device->mutex);
> > > +
> > > +	if (dt->device->users) {
> > > +		if (device_may_wakeup(&client->dev)) {
> > > +			enable_irq_wake(client->irq);
> > 
> > I think this part should happen regardless of whether device has users,
> > only non wakeup source case needs it.
> 
> Hmm.. why would one want to enable irq_wake when there are no users?
> Wouldn't this cause the device to wakeup at every irq and report an
> switch event that no one listens to?

You are suspending the system and want to have this device as a wakeup
source. Note: not wake up _device_ at every IRQ but wake up the whole
_system_ when device generates an IRQ while system is asleep.
It does not matter whether there are users for the events; you
want the system to wake up.

At least this is the usual semantics.

-- 
Dmitry
