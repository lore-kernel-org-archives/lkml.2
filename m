Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762274Ab2DLSmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:42:06 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:9745 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757772Ab2DLSmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:42:03 -0400
Message-ID: <1334256118.2497.9.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [RFC PATCH 1/2] net: ethtool: Add capability to retrieve
 plug-in module EEPROM
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stuart Hodgson <smhodgson@solarflare.com>
CC: <netdev@vger.kernel.org>, <bruce.w.allan@intel.com>,
        <mirq-linux@rere.qmqm.pl>, <decot@google.com>,
        <amit.salecha@qlogic.com>, <alexander.h.duyck@intel.com>,
        <davem@davemloft.net>, <linux-kernel@vger.kernel.org>
Date: Thu, 12 Apr 2012 19:41:58 +0100
In-Reply-To: <4F869DF0.1000709@solarflare.com>
References: <4F71FE0A.3060203@solarflare.com>
	  <1333389160.2623.30.camel@bwh-desktop.uk.solarflarecom.com>
	  <4F85B639.5090900@solarflare.com>
	  <1334168217.2552.5.camel@bwh-desktop.uk.solarflarecom.com>
	 <1334187728.2552.7.camel@bwh-desktop.uk.solarflarecom.com>
	 <4F869DF0.1000709@solarflare.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18832.004
X-TM-AS-Result: No--22.678100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-12 at 10:18 +0100, Stuart Hodgson wrote:
> On 12/04/12 00:42, Ben Hutchings wrote:
[...]
> > Maybe we should start by refactoring ethtool_get_eeprom() so we can
> > reuse most of its code in ethtool_get_module_eeprom(), rather than
> > having to worry about what the maximum size of a module EEPROM might be
> > and whether we need a loop:
> >
> > Subject: ethtool: Split ethtool_get_eeprom() to allow for additional EEPROM accessors
[...]
> > @@ -771,7 +770,7 @@ static int ethtool_get_eeprom(struct net_device *dev, void __user *useraddr)
> >   		return -EINVAL;
> >
> >   	/* Check for exceeding total eeprom len */
> > -	if (eeprom.offset + eeprom.len>  ops->get_eeprom_len(dev))
> > +	if (eeprom.offset + eeprom.len>  total_len)
> >   		return -EINVAL;
> >
> >   	data = kmalloc(PAGE_SIZE, GFP_USER);
> 
> Should this not be eeprom.len?
[...]

No, because this function loops over PAGE_SIZE chunks.  That's
presumably necessary for large NIC EEPROMs, and if we reuse it we won't
have to wory about whether it's ever necessary for large module EEPROMs.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

