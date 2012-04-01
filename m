Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab2DAF4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 01:56:44 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:29678
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475Ab2DAF4m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 01:56:42 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zzc89bh1803M1432N98dK1447Mzz1202hzzz2dh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1SDUD-02-22T-02
X-M-MSG: 
Date: Sun, 1 Apr 2012 13:56:03 +0800
From: Aaron Lu <aaron.lu@amd.com>
To: Lin Ming <ming.m.lin@intel.com>
CC: Len Brown <lenb@kernel.org>, "Rafeal J. Wysocki" <rjw@sisk.pl>,
        <linux-acpi@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
Message-ID: <20120401055603.GA11505@localhost.amd.com>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com>
 <1333258053.2939.22.camel@minggr>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1333258053.2939.22.camel@minggr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 01 Apr 2012 05:56:32.0340 (UTC) FILETIME=[3066C940:01CD0FCC]
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Apr 01, 2012 at 01:27:33PM +0800, Lin Ming wrote:
> > -		if (device->power.states[state].flags.explicit_set) {
> > +		/* If state is D3 Cold, try to evaluate _PS3 first */
> > +		if (state == ACPI_STATE_D3_COLD) {
> > +			explicit_set = (ps - 1)->flags.explicit_set;
> > +			object_name[3] -= 1;
> > +		}
> 
> I'm not sure whether this works or not.
> 
> From ACPI spec,
> 
> _PS3 "is used to put the specific device into its D3hot or D3 state"
> 
> D3 neither means D3hot nor D3cold. It's an old term before D3hot and
> D3cold were introduced.
I guess D3 has to mean something, right? :-)

Here is the problem, there is no _PR3 in AMD's implementation, just _PS3.
And since _S0W evaluates 4, I've to put this device into D3 cold state
with _PS3.

And the ACPI does have some words like:

------
Platform/drivers must assume that the device will have power completely
removed when the device is place into “D3” via _PS3
------

This is in section 7.2.11: _PR3.

> 
> Another problem:
> 
> With your patch, both D3hot and D3cold will evaluate _PS3, right?
> 
Yes.

> Will it have problem on AMD platform if you try to put ODD into D3hot
> state? _PS3 is evaluated, so it actually enters D3Cold state.

There is no D3 hot support for this device(from the firmware's
perspective), either it is at D0(via _PS0), or it will be at D3 cold(via
_PS3).


Thanks for the review.

-Aaron

