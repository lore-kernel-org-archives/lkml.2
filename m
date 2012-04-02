Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2DBSOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:14:43 -0400
Received: from mail.solarflare.com ([216.237.3.220]:53655 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752329Ab2DBSOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:14:42 -0400
Message-ID: <1333390478.2623.44.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [RFC PATCH 1/2] net: ethtool: Add capability to retrieve
 plug-in module EEPROM
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stuart Hodgson <smhodgson@solarflare.com>
CC: <netdev@vger.kernel.org>, <bruce.w.allan@intel.com>,
        <mirq-linux@rere.qmqm.pl>, <decot@google.com>,
        <amit.salecha@qlogic.com>, <alexander.h.duyck@intel.com>,
        <davem@davemloft.net>, <linux-kernel@vger.kernel.org>
Date: Mon, 2 Apr 2012 19:14:38 +0100
In-Reply-To: <1333389160.2623.30.camel@bwh-desktop.uk.solarflarecom.com>
References: <4F71FE0A.3060203@solarflare.com>
	 <1333389160.2623.30.camel@bwh-desktop.uk.solarflarecom.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18812.005
X-TM-AS-Result: No--18.149200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 18:52 +0100, Ben Hutchings wrote:
[...]
> > +    ret = ops->get_module_eeprom(dev, &eeprom, data);
> > +    if (ret)
> > +        goto out;
> > +
> > +
> > +    if (copy_to_user(userbuf, data, eeprom.len)) {
> > +        ret = -EFAULT;
> > +        goto out;
> > +    }
> > +
> > +    if (copy_to_user(useraddr, &eeprom, sizeof(eeprom)))
> > +        ret = -EFAULT;
> [...]
> 
> I think you can drop this last copy as there's no information to return
> in the eeprom structure itself.
[...]

This is not the case because we need to cover short reads.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

