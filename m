Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858Ab2DKSRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:17:04 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:51535 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755908Ab2DKSRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:17:01 -0400
Message-ID: <1334168217.2552.5.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [RFC PATCH 1/2] net: ethtool: Add capability to retrieve
 plug-in module EEPROM
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stuart Hodgson <smhodgson@solarflare.com>
CC: <netdev@vger.kernel.org>, <bruce.w.allan@intel.com>,
        <mirq-linux@rere.qmqm.pl>, <decot@google.com>,
        <amit.salecha@qlogic.com>, <alexander.h.duyck@intel.com>,
        <davem@davemloft.net>, <linux-kernel@vger.kernel.org>
Date: Wed, 11 Apr 2012 19:16:57 +0100
In-Reply-To: <4F85B639.5090900@solarflare.com>
References: <4F71FE0A.3060203@solarflare.com>
	 <1333389160.2623.30.camel@bwh-desktop.uk.solarflarecom.com>
	 <4F85B639.5090900@solarflare.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18830.005
X-TM-AS-Result: No--15.154200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-11 at 17:50 +0100, Stuart Hodgson wrote:
> On 02/04/12 18:52, Ben Hutchings wrote:
[...]
> >> --- a/net/core/ethtool.c
> >> +++ b/net/core/ethtool.c
[...]
> >> +    if (eeprom.offset + eeprom.len>  modinfo.eeprom_len)
> >> +        return -EINVAL;
> >> +
> >> +    data = kmalloc(PAGE_SIZE, GFP_USER);
> >> +    if (!data)
> >> +        return -ENOMEM;
> >
> > What if some device has a larger EEPROM?  Surely this length should be
> > eeprom.len.
> >
> 
> Do you mean what if the eeprom length in te device is larger than
> PAGE_SIZE?

Yes.

> If so then it should really use modinfo.eeprom_len since
> this the size of the data. eeprom.len could be arbitary.

No, eeprom.len is the size of the data and we've already validated it at
this point.

Ben.


