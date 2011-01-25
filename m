Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab1AYH7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 02:59:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:7519 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab1AYH7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 02:59:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,373,1291622400"; 
   d="scan'208";a="596176219"
Subject: Re: Thermal kernel events API to userspace - Was: Re: thermal:
 Avoid CONFIG_NET compile dependency
From: Zhang Rui <rui.zhang@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Thomas Renninger <trenn@suse.de>, "R, Durgadoss" <durgadoss.r@intel.com>,
        "jdelvare@novell.com" <jdelvare@novell.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
	<linux-trace-users@vger.kernel.org>
In-Reply-To: <20110124160747.GD6424@khazad-dum.debian.net>
References: <D6D887BA8C9DFF48B5233887EF046541094482F511@bgsmsx502.gar.corp.intel.com>
	 <D6D887BA8C9DFF48B5233887EF046541094488B86F@bgsmsx502.gar.corp.intel.com>
	 <201101241135.23576.trenn@suse.de> <201101241407.28376.trenn@suse.de>
	 <20110124160747.GD6424@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 15:57:49 +0800
Message-ID: <1295942269.1866.1201.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 00:07 +0800, Henrique de Moraes Holschuh wrote:
> On Mon, 24 Jan 2011, Thomas Renninger wrote:
> > I wonder whether netlink is the way to go for thermal
> > events at all.
> > Sending an udev event would already contain the sysfs
> > path to the thermal device. A variable which thermal event
> > got thrown could get added and userspace can read out the rest
> > easily from sysfs files. But I expect udev is not intended
> > for such general events?
> 
> udev is heavyweight in the userspace side, we'd be much better off using the
> ACPI event interface (which is netlink), or a new one to deliver system
> status events, instead of continously abusing udev for this stuff.
> 
> > > > Also, the thermal_aux0 and _aux1, we can use the final format specified by you.
> > > > enum events {
> > > >  	THERMAL_CRITICAL,
> > > >  	/* user defined thermal events */
> > > >  	THERMAL_USER_AUX0,
> > > >  	THERMAL_USER_AUX1,
> > > >  	THERMAL_DEV_FAULT,
> > > >  };
> 
> Please give us at least two levels of thermal alarm: critical and emergency
> (or warning and critical -- it doesn't matter much, as long as there are at
> least two levels, and which one comes first is defined by the
> specification).  I'd have immediate use for them on thinkpads.
> 
> It is probably best to have three levels (warning, critical, emergency).
> Best not to tie the API/ABI to the notion of "too hot", one can also alarm
> when it starts to get to cold.
> 
when it's the "too hot" case, what kind of action should be taken upon
the warning/critical/emergency events?
I mean what's the difference between these three levels.

thanks,
rui


