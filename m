Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab1AYKMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:12:34 -0500
Received: from cantor.suse.de ([195.135.220.2]:34561 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab1AYKMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:12:32 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: Thermal kernel events API to userspace - Was: Re: thermal: Avoid CONFIG_NET compile dependency
Date: Tue, 25 Jan 2011 11:12:28 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-8.99.14.138eeaa-desktop; KDE/4.5.95; x86_64; ; )
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        "jdelvare@novell.com" <jdelvare@novell.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
	<linux-trace-users@vger.kernel.org>
References: <D6D887BA8C9DFF48B5233887EF046541094482F511@bgsmsx502.gar.corp.intel.com> <20110124160747.GD6424@khazad-dum.debian.net> <1295942269.1866.1201.camel@rui>
In-Reply-To: <1295942269.1866.1201.camel@rui>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101251112.28340.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 25, 2011 08:57:49 AM Zhang Rui wrote:
> On Tue, 2011-01-25 at 00:07 +0800, Henrique de Moraes Holschuh wrote:
> > On Mon, 24 Jan 2011, Thomas Renninger wrote:
> > > I wonder whether netlink is the way to go for thermal
> > > events at all.
> > > Sending an udev event would already contain the sysfs
> > > path to the thermal device. A variable which thermal event
> > > got thrown could get added and userspace can read out the rest
> > > easily from sysfs files. But I expect udev is not intended
> > > for such general events?
> > 
> > udev is heavyweight in the userspace side, we'd be much better off using the
> > ACPI event interface (which is netlink), or a new one to deliver system
> > status events, instead of continously abusing udev for this stuff.
> > 
> > > > > Also, the thermal_aux0 and _aux1, we can use the final format specified by you.
> > > > > enum events {
> > > > >  	THERMAL_CRITICAL,
> > > > >  	/* user defined thermal events */
> > > > >  	THERMAL_USER_AUX0,
> > > > >  	THERMAL_USER_AUX1,
> > > > >  	THERMAL_DEV_FAULT,
> > > > >  };
> > 
> > Please give us at least two levels of thermal alarm: critical and emergency
> > (or warning and critical -- it doesn't matter much, as long as there are at
> > least two levels, and which one comes first is defined by the
> > specification).  I'd have immediate use for them on thinkpads.
What kind of thinkpad specific events are these and what actions
should be taken if they happen?
 
> > It is probably best to have three levels (warning, critical, emergency).
> > Best not to tie the API/ABI to the notion of "too hot", one can also alarm
> > when it starts to get to cold.
> > 
> when it's the "too hot" case, what kind of action should be taken upon
> the warning/critical/emergency events?
> I mean what's the difference between these three levels.
I could imagine there is quite some HW out there
with quite different thermal events.
What other actions userspace would take beside logging the event,
telling the user that a fan is switched on, CPU or whatever device
gets throttled. Logging such specific info can only be implemented
in the driver itself and would get lost when exporting things through
a generic thermal interface.

I wonder which events would need userspace to take specific
(configured) actions at all and what kind of action it could be.

What is THERMAL_USER_AUX0?
When will it get thrown and what is userspace expected to do?

    Thomas
