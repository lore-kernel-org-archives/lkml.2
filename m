Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2DAG3D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 02:29:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:49236 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab2DAG3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 02:29:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="124127434"
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
From: Lin Ming <ming.m.lin@intel.com>
To: Aaron Lu <aaron.lu@amd.com>
Cc: Len Brown <lenb@kernel.org>, "Rafeal J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
In-Reply-To: <20120401055603.GA11505@localhost.amd.com>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com>
	 <1333258053.2939.22.camel@minggr>
	 <20120401055603.GA11505@localhost.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Apr 2012 14:28:57 +0800
Message-ID: <1333261737.2939.84.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-01 at 13:56 +0800, Aaron Lu wrote:
> Hi,
> 
> On Sun, Apr 01, 2012 at 01:27:33PM +0800, Lin Ming wrote:
> > > -		if (device->power.states[state].flags.explicit_set) {
> > > +		/* If state is D3 Cold, try to evaluate _PS3 first */
> > > +		if (state == ACPI_STATE_D3_COLD) {
> > > +			explicit_set = (ps - 1)->flags.explicit_set;
> > > +			object_name[3] -= 1;
> > > +		}
> > 
> > I'm not sure whether this works or not.
> > 
> > From ACPI spec,
> > 
> > _PS3 "is used to put the specific device into its D3hot or D3 state"
> > 
> > D3 neither means D3hot nor D3cold. It's an old term before D3hot and
> > D3cold were introduced.
> I guess D3 has to mean something, right? :-)
> 
> Here is the problem, there is no _PR3 in AMD's implementation, just _PS3.
> And since _S0W evaluates 4, I've to put this device into D3 cold state
> with _PS3.
> 
> And the ACPI does have some words like:
> 
> ------
> Platform/drivers must assume that the device will have power completely
> removed when the device is place into “D3” via _PS3
> ------
> 
> This is in section 7.2.11: _PR3.
> 
> > 
> > Another problem:
> > 
> > With your patch, both D3hot and D3cold will evaluate _PS3, right?
> > 
> Yes.
> 
> > Will it have problem on AMD platform if you try to put ODD into D3hot
> > state? _PS3 is evaluated, so it actually enters D3Cold state.
> 
> There is no D3 hot support for this device(from the firmware's
> perspective), either it is at D0(via _PS0), or it will be at D3 cold(via
> _PS3).

But this is the generic code. We can't only consider some special
device.

Maybe we need some flag to tell which D3 state _PS3 is used for.

Lin Ming

> 
> 
> Thanks for the review.
> 
> -Aaron
> 


