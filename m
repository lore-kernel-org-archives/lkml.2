Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab2DHXsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 19:48:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab2DHXsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 19:48:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
Date: Mon, 9 Apr 2012 01:53:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Lin Ming <ming.m.lin@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com> <1333593080.11327.22.camel@minggr> <20120405025609.GA5208@localhost.amd.com>
In-Reply-To: <20120405025609.GA5208@localhost.amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204090153.03379.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 05, 2012, Aaron Lu wrote:
> Hi,
> 
> On Thu, Apr 05, 2012 at 10:31:20AM +0800, Lin Ming wrote:
> > > 
> > > The only situation where a device can be put into ACPI D3_hot (which is not
> > > the same as PCI D3_hot, mind you) is when:
> > > 
> > > (1) There is _PR3 listing some of the device's power resources as "on".
> > > (2) The power resources listed by the _PR3 as "off" are turned off and the
> > >     power resources listed by the _PR3 as "on" are left in the "on" state.
> > 
> > I don't understand item (2):
> > 
> > If the power resource is listed as "off", which means it's already
> > turned off. Then why should it be turned off again?
> 
> Rafael,
> I think you misunderstand the meaning of _PR3.
> The _PR3 will evaluate a list of power resources, not two lists(one "on"
> list and one "off" list), as illustrated by Ming below.

Yes, the other list is returned by _PR0.

> And for a device to be put to D3 hot, it should:
> 1 execuate _PS3 first if available
> 2 turn on all the power resources referenced by _PR3

Not turn them on, but rather leave then in the "on" state.

> And for a device to be put to D3 cold, it should:
> 1 execute _PS3 first if available
> 2 turn off power resources referenced by _PRx, where x is the previous
> state number of the device. Say if the device is put to D3 cold from D0,
> the x would be 0.
> 
> Is this correct?

Yes, it is, except that you only need to evaluate _PR0 to get the entire
list of device's power resources and from there you know which resources to
turn off to put the device into D3_cold.

And BTW, please note that if any power resources are shared between devices,
then it may be unclear which state an individual device is at the moment.  For
example, if dev0 depends on power resources r1, r2, r3 and dev1 depends
on power resources r3, r4, r5, then dev0 will not really go to D3(cold) until
r3 is turned off, but this may be held by dev1.

Thanks,
Rafael
