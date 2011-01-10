Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab1AJG5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 01:57:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:35248 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab1AJG5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 01:57:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,299,1291622400"; 
   d="scan'208";a="645137652"
Date: Mon, 10 Jan 2011 14:57:10 +0800
From: Yin Kangkai <kangkai.yin@linux.intel.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Liu, Bing Wei" <bing.wei.liu@intel.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH V2] platform-driver-x86: ACPI EC Extra driver for
 Oaktrail
Message-ID: <20110110065710.GI30215@kai-debian>
References: <20110106025949.GJ9496@kai-debian>
 <20110107074115.GH30215@kai-debian>
 <AANLkTik=x-OTWGzRB2BgB1u748EDM=B3nsGpWbR8D-C5@mail.gmail.com>
 <20110107112409.GU9496@kai-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110107112409.GU9496@kai-debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-07, 19:24 +0800, Yin Kangkai wrote:
> On 2011-01-07, 09:56 +0100, Corentin Chary wrote:
> > > +static struct rfkill *oaktrail_rfkill_new(char *name, enum rfkill_type type,
> > > +                                         unsigned long mask)
> > > +{
> > > +       int err;
> > > +       struct rfkill *rfkill_dev;
> > > +
> > > +       rfkill_dev = rfkill_alloc(name, &oaktrail_device->dev, type,
> > > +                                 &oaktrail_rfkill_ops, (void *)mask);
> > > +       if (!rfkill_dev)
> > > +               return ERR_PTR(-ENOMEM);
> > > +
> > > +       err = rfkill_register(rfkill_dev);
> > 
> > Maybe you should add a rfkill_init_sw_state() call here, to be sure
> > that the rfkill initial state is right.
> 
> Yes, agree with you, and I'm trying to do that, add a
> rfkill_init_sw_state between rfkill_alloc() and rfkill_register()...
> 
> +       ec_read(OT_EC_DEVICE_STATE_ADDRESS, &value);
> +       rfkill_init_sw_state(rfkill_dev, (value & mask) != 1);
> 
> 
> However, test shows the EC seems not ready yet when booting runs here
> (value = 0), and then all the radio set as "blocked". Hence the radio
> state can't be persistent during reboot.. This is not we want.
> 
> Also tried to read out the EC address a little bit later, seems the EC
> won't be ready until very late.
> 
> Am I doing something wrong? or I need to check with HW guy about this.

It turns out that is because of a bug in driver itself and the way I'm
doing "rebooting" is wrong..

Yes, the rfkill_init_sw_state() is needed, otherwise,
rfkill_register() will wrongly set the rfkill status.

Am sending the V3 patch right away.

Kangkai
