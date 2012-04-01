Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab2DAHpS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 03:45:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:59517 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab2DAHpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 03:45:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="124144669"
Message-ID: <1333266346.2387.110.camel@rui.sh.intel.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lin Ming <ming.m.lin@intel.com>, Aaron Lu <aaron.lu@amd.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
Date: Sun, 01 Apr 2012 15:45:46 +0800
In-Reply-To: <201204010923.18330.rjw@sisk.pl>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com>
	 <20120401055603.GA11505@localhost.amd.com>
	 <1333261737.2939.84.camel@minggr> <201204010923.18330.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 日, 2012-04-01 at 09:23 +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> Sorry for the delayed response, I've been travelling recently.
> 
> On Sunday, April 01, 2012, Lin Ming wrote:
> > On Sun, 2012-04-01 at 13:56 +0800, Aaron Lu wrote:
> > > Hi,
> > > 
> > > On Sun, Apr 01, 2012 at 01:27:33PM +0800, Lin Ming wrote:
> > > > > -		if (device->power.states[state].flags.explicit_set) {
> > > > > +		/* If state is D3 Cold, try to evaluate _PS3 first */
> > > > > +		if (state == ACPI_STATE_D3_COLD) {
> > > > > +			explicit_set = (ps - 1)->flags.explicit_set;
> > > > > +			object_name[3] -= 1;
> > > > > +		}
> > > > 
> > > > I'm not sure whether this works or not.
> > > > 
> > > > From ACPI spec,
> > > > 
> > > > _PS3 "is used to put the specific device into its D3hot or D3 state"
> > > > 
> > > > D3 neither means D3hot nor D3cold. It's an old term before D3hot and
> > > > D3cold were introduced.
> > > I guess D3 has to mean something, right? :-)
> 
> Well, not necessarily.
> 
> The problem is what state the _PS3 method puts the device into: D3_hot or
> D3_cold.
> 
> Unfortunately, as far as I can say, ACPI 4.0 didn't specify any "official"
> mapping between the "old" D3 and the "new" D3_{hod|cold} states, so we need to
> figure out something.  In my opinion, the only reasonable approach is to
> assume that the state _PS3 puts the device into is always D3_cold, becuase
> _PS3 may remove power completely from the device.  It may not do that, but
> we _must_ assume it does that in general.
> 
There is a problem that I can think of.
Say currently, ACPI always returns D3 when _PS3 exists.
And this "ACPI_STATE_D3" is translated to PCI_D3hot.
But with this approach, we're going to put these devices to PCI_D3cold
instead, right?
I'm not against this approach, but this may affect a lot of PCI devices,
which we need to take care of, no?

thanks,
rui


