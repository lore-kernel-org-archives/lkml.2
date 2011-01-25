Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab1AYPv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 10:51:57 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49755 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977Ab1AYPvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:51:55 -0500
X-Sasl-enc: F/UqcN1TCHoNE3Xi/HAG9xjWdMmPm+W3d/VwzerAfGrN 1295970715
Date: Tue, 25 Jan 2011 13:51:52 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Thomas Renninger <trenn@suse.de>, "R, Durgadoss" <durgadoss.r@intel.com>,
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
Message-ID: <20110125155152.GC14803@khazad-dum.debian.net>
References: <D6D887BA8C9DFF48B5233887EF046541094482F511@bgsmsx502.gar.corp.intel.com>
 <D6D887BA8C9DFF48B5233887EF046541094488B86F@bgsmsx502.gar.corp.intel.com>
 <201101241135.23576.trenn@suse.de>
 <201101241407.28376.trenn@suse.de>
 <20110124160747.GD6424@khazad-dum.debian.net>
 <1295942269.1866.1201.camel@rui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295942269.1866.1201.camel@rui>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011, Zhang Rui wrote:
> On Tue, 2011-01-25 at 00:07 +0800, Henrique de Moraes Holschuh wrote:
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
> > 
> > It is probably best to have three levels (warning, critical, emergency).
> > Best not to tie the API/ABI to the notion of "too hot", one can also alarm
> > when it starts to get to cold.
> > 
> when it's the "too hot" case, what kind of action should be taken upon
> the warning/critical/emergency events?
> I mean what's the difference between these three levels.

*ASSUMING* it is monitoring the box (which is a damn big assumption, and
should be stated outright):

Warning: do something to stop generating so much heat, warn user, try to
increase cooling.  Let userspace bother with this.

Critical: *STOP* generating so much heat (throttle cpu, throttle GPU,
shutdown non-critical devices, etc).  Increase cooling to max.  WARN the
user that a machine emergency exists and shutdown is imminent, and that he
has to power off or sleep to ram *NOW*.

Emergency: emergency sync, and initiate immediate suspend to ram. If that
fails, initiate emergency powerdown.

Likely one wants kernel notifiers for this stuff, too, so that we can have
in-kernel handlers (optional or not, configurable or not, that is orthogonal
to the issue) that can try to do something to help.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
