Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab1AXQHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:07:53 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43058 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753331Ab1AXQHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:07:51 -0500
X-Sasl-enc: s/fts5yd46/6M4gvp+Gp3K1rOZVx/mXba+J9ABR4r77J 1295885270
Date: Mon, 24 Jan 2011 14:07:47 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Renninger <trenn@suse.de>
Cc: "R, Durgadoss" <durgadoss.r@intel.com>, jdelvare@novell.com,
        "Zhang, Rui" <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-perf-users@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-trace-users@vger.kernel.org
Subject: Re: Thermal kernel events API to userspace - Was: Re: thermal:
 Avoid CONFIG_NET compile dependency
Message-ID: <20110124160747.GD6424@khazad-dum.debian.net>
References: <D6D887BA8C9DFF48B5233887EF046541094482F511@bgsmsx502.gar.corp.intel.com>
 <D6D887BA8C9DFF48B5233887EF046541094488B86F@bgsmsx502.gar.corp.intel.com>
 <201101241135.23576.trenn@suse.de>
 <201101241407.28376.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101241407.28376.trenn@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011, Thomas Renninger wrote:
> I wonder whether netlink is the way to go for thermal
> events at all.
> Sending an udev event would already contain the sysfs
> path to the thermal device. A variable which thermal event
> got thrown could get added and userspace can read out the rest
> easily from sysfs files. But I expect udev is not intended
> for such general events?

udev is heavyweight in the userspace side, we'd be much better off using the
ACPI event interface (which is netlink), or a new one to deliver system
status events, instead of continously abusing udev for this stuff.

> > > Also, the thermal_aux0 and _aux1, we can use the final format specified by you.
> > > enum events {
> > >  	THERMAL_CRITICAL,
> > >  	/* user defined thermal events */
> > >  	THERMAL_USER_AUX0,
> > >  	THERMAL_USER_AUX1,
> > >  	THERMAL_DEV_FAULT,
> > >  };

Please give us at least two levels of thermal alarm: critical and emergency
(or warning and critical -- it doesn't matter much, as long as there are at
least two levels, and which one comes first is defined by the
specification).  I'd have immediate use for them on thinkpads.

It is probably best to have three levels (warning, critical, emergency).
Best not to tie the API/ABI to the notion of "too hot", one can also alarm
when it starts to get to cold.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
