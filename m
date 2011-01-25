Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab1AYQLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 11:11:06 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40299 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236Ab1AYQLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 11:11:03 -0500
X-Sasl-enc: 1kfoZRZk5FPkBUy67x0Cr/tdm2H2oFyQbAUaWbY/ldVK 1295971862
Date: Tue, 25 Jan 2011 14:10:59 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Renninger <trenn@suse.de>
Cc: Zhang Rui <rui.zhang@intel.com>, "R, Durgadoss" <durgadoss.r@intel.com>,
        "jdelvare@novell.com" <jdelvare@novell.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
	<linux-trace-users@vger.kernel.org>
Subject: Re: Thermal kernel events API to userspace - Was: Re: thermal:
 Avoid CONFIG_NET compile dependency
Message-ID: <20110125161059.GD14803@khazad-dum.debian.net>
References: <D6D887BA8C9DFF48B5233887EF046541094482F511@bgsmsx502.gar.corp.intel.com>
 <20110124160747.GD6424@khazad-dum.debian.net>
 <1295942269.1866.1201.camel@rui>
 <201101251112.28340.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101251112.28340.trenn@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011, Thomas Renninger wrote:
> > > Please give us at least two levels of thermal alarm: critical and emergency
> > > (or warning and critical -- it doesn't matter much, as long as there are at
> > > least two levels, and which one comes first is defined by the
> > > specification).  I'd have immediate use for them on thinkpads.
> What kind of thinkpad specific events are these and what actions
> should be taken if they happen?

So far:  Battery temperature critical and emergency, Generic system sensor
temperature critical and emergency.

In all cases, the recommended actions are imediate notification for the
user, and in the case of the emergency level, immediate action, where action
is "suspend to ram" or shutdown.

Right now all they do is to prinkt at suitable "horrible things are about to
happen" severity levels (KERN_CRIT for critical, and KERN_ALERT for
emergency).  In a few sensible desktop environments and distros, this causes
a notification to show up on the user's screen.

Oh, and it also relays the thinkpad-specific event through the ACPI event
pipe, but I don't know of any userspace application doing something with it,
and nobody ever tried to bribe me into writing one by suppling me with a new
T-series thinkpad :)

> I wonder which events would need userspace to take specific
> (configured) actions at all and what kind of action it could be.

All of them can have sensible generic actions.  See my other email.

> What is THERMAL_USER_AUX0?
> When will it get thrown and what is userspace expected to do?

Good question.  What use are those "user defined" events in a generic
interface, anyway?  You will have to know exactly what device is issuing the
"generic user defined" event, and what it means for that device.

When you need a device-specific interface, you design one that is well
defined, such as thinkpad-acpi's thinkpad-specific "acpi" events.  If you
get any thinkpad-acpi specific event, you know exactly what it is, and
nothing else ever issues those events, so you will never get them from
somewhere else with a different meaning.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
