Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab1AZHOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:14:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:21512 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab1AZHOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:14:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,379,1291622400"; 
   d="scan'208";a="380027557"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Thomas Renninger <trenn@suse.de>
CC: "R, Durgadoss" <durgadoss.r@intel.com>,
        "jdelvare@novell.com" <jdelvare@novell.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
	<linux-trace-users@vger.kernel.org>
Date: Wed, 26 Jan 2011 15:14:16 +0800
Subject: RE: Thermal kernel events API to userspace - Was: Re: thermal:
 Avoid CONFIG_NET compile dependency
Thread-Topic: Thermal kernel events API to userspace - Was: Re: thermal:
 Avoid CONFIG_NET compile dependency
Thread-Index: Acu8qnk6ECp4Cr5fRpe0Ht1bJA4YEwAelXlA
Message-ID: <CF2F38D4AE21BB4CB845318E4C5ECB6731CC866A@shsmsx501.ccr.corp.intel.com>
References: <D6D887BA8C9DFF48B5233887EF046541094482F511@bgsmsx502.gar.corp.intel.com>
 <20110124160747.GD6424@khazad-dum.debian.net>
 <1295942269.1866.1201.camel@rui> <201101251112.28340.trenn@suse.de>
 <20110125161059.GD14803@khazad-dum.debian.net>
In-Reply-To: <20110125161059.GD14803@khazad-dum.debian.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Henrique de Moraes Holschuh [mailto:hmh@hmh.eng.br]
> Sent: Wednesday, January 26, 2011 12:11 AM
> To: Thomas Renninger
> Cc: Zhang, Rui; R, Durgadoss; jdelvare@novell.com; Len Brown; linux-
> acpi@vger.kernel.org; Kay Sievers; linux-perf-users@vger.kernel.org;
> linux-kernel@vger.kernel.org; linux-trace-users@vger.kernel.org
> Subject: Re: Thermal kernel events API to userspace - Was: Re: thermal:
> Avoid CONFIG_NET compile dependency
> Importance: High
> 
> On Tue, 25 Jan 2011, Thomas Renninger wrote:
> > > > Please give us at least two levels of thermal alarm: critical and
> emergency
> > > > (or warning and critical -- it doesn't matter much, as long as
> there are at
> > > > least two levels, and which one comes first is defined by the
> > > > specification).  I'd have immediate use for them on thinkpads.
> > What kind of thinkpad specific events are these and what actions
> > should be taken if they happen?
> 
> So far:  Battery temperature critical and emergency, Generic system
> sensor
> temperature critical and emergency.
> 
> In all cases, the recommended actions are imediate notification for the
> user, and in the case of the emergency level, immediate action, where
> action
> is "suspend to ram" or shutdown.
> 
> Right now all they do is to prinkt at suitable "horrible things are
> about to
> happen" severity levels (KERN_CRIT for critical, and KERN_ALERT for
> emergency).  In a few sensible desktop environments and distros, this
> causes
> a notification to show up on the user's screen.
> 
> Oh, and it also relays the thinkpad-specific event through the ACPI
> event
> pipe, but I don't know of any userspace application doing something
> with it,
> and nobody ever tried to bribe me into writing one by suppling me with
> a new
> T-series thinkpad :)
> 
> > I wonder which events would need userspace to take specific
> > (configured) actions at all and what kind of action it could be.
> 
> All of them can have sensible generic actions.  See my other email.
> 
> > What is THERMAL_USER_AUX0?
> > When will it get thrown and what is userspace expected to do?
> 
> Good question.  What use are those "user defined" events in a generic
> interface, anyway?  You will have to know exactly what device is
> issuing the
> "generic user defined" event, and what it means for that device.
> 
> When you need a device-specific interface, you design one that is well
> defined, such as thinkpad-acpi's thinkpad-specific "acpi" events.  If
> you
> get any thinkpad-acpi specific event, you know exactly what it is, and
> nothing else ever issues those events, so you will never get them from
> somewhere else with a different meaning.
>
I think you are talking about something like this:
enum events {
	/* generic thermal event */
	THERMAL_WARN,
	THERMAL_EMERG,
	THERMAL_CRIT,
	/* coretemp thermal events */
	TEHRMAL_CT_AUX0,
	TEHRMAL_CT_AUX1,
	/* Thinkpad battery thermal events */
	THERMAL_TP_BAT_CRIT,
	THERMAL_TP_BAT_EMERG,
	THERMAL_DEV_FAULT,
};
Right?


> --
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh
