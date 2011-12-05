Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1LEFxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 00:53:32 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:29405 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab1LEFx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 00:53:29 -0500
X-SpamScore: -10
X-BigFish: VS-10(zz1432N4015Lzz1202hzzz2dh2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Chen Peter-B29397 <B29397@freescale.com>
To: NeilBrown <neilb@suse.de>, Ming Lei <tom.leiming@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "hzpeterchen@gmail.com" <hzpeterchen@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: RE: [PATCH 1/1] driver core: disable device's runtime pm during
 shutdown
Thread-Topic: [PATCH 1/1] driver core: disable device's runtime pm during
 shutdown
Thread-Index: AQHMoxycXXQ805A53UK1qWqObZXQz5Wtgh2AgAF1WwCAHcYOAIAAXD0AgAAYTAD//6hXoA==
Date: Mon, 5 Dec 2011 05:53:27 +0000
Message-ID: <35AB98346D25394A9354ED89C4D76587228F32@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
	<201111142327.37524.rjw@sisk.pl>	<20111115005951.GB26360@kroah.com>
	<201111160016.09174.rjw@sisk.pl>	<20111205085632.5976fe96@notabene.brown>
	<CACVXFVNkapRDJ8QkgmJCh+n1c2+7cHBiLf1ef22Nfdd8YrPpGg@mail.gmail.com>
 <20111205155338.1bd658b9@notabene.brown>
In-Reply-To: <20111205155338.1bd658b9@notabene.brown>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.127]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 
> > > So it is asleep when the new pm_runtime_disable() call is made, so it
> stays
> > > asleep, omap_i2c_xfer cannot wake it, the transfer doesn't happen and
> the
> > > system doesn't get powered off.
> > >
> > > So here is a device that should *not* have pm disabled at shutdown.
> > >
> > > So I feel this fix is a little too heavy-handed.
> >
> > Maybe the device's runtime PM should not be disabled if
> > there is no ->shutdown defined in its driver, how about the blew?
> 
> Thanks, but that won't actually help.
> 
> dev->bus->shutdown is i2c_device_shutdown so there is a shutdown method.
> However i2c_device_shutdown just finds the driver can calls
> driver->shutdown(), and that is the 'shutdown' that is NULL.
> 
Then, i2c should be registered before than twl4030 as a platform device, since
twl4030 is an i2c device. Just let i2c shut down later than twl4030's. 

> Thanks,
> NeilBrown
> 
> 
> 

