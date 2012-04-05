Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab2DEC4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 22:56:51 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:38985
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932230Ab2DEC4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 22:56:49 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zz1432N98dK4015Izz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1ZK66-01-0W4-02
X-M-MSG: 
Date: Thu, 5 Apr 2012 10:56:09 +0800
From: Aaron Lu <aaron.lu@amd.com>
To: Lin Ming <ming.m.lin@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Len Brown <lenb@kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Andiry Xu <andiry.xu@amd.com>,
        Alex He <alex.he@amd.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
Message-ID: <20120405025609.GA5208@localhost.amd.com>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com>
 <20120401055603.GA11505@localhost.amd.com>
 <1333261737.2939.84.camel@minggr>
 <201204010923.18330.rjw@sisk.pl>
 <1333593080.11327.22.camel@minggr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1333593080.11327.22.camel@minggr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 05 Apr 2012 02:56:19.0314 (UTC) FILETIME=[ACFCF520:01CD12D7]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 05, 2012 at 10:31:20AM +0800, Lin Ming wrote:
> > 
> > The only situation where a device can be put into ACPI D3_hot (which is not
> > the same as PCI D3_hot, mind you) is when:
> > 
> > (1) There is _PR3 listing some of the device's power resources as "on".
> > (2) The power resources listed by the _PR3 as "off" are turned off and the
> >     power resources listed by the _PR3 as "on" are left in the "on" state.
> 
> I don't understand item (2):
> 
> If the power resource is listed as "off", which means it's already
> turned off. Then why should it be turned off again?

Rafael,
I think you misunderstand the meaning of _PR3.
The _PR3 will evaluate a list of power resources, not two lists(one "on"
list and one "off" list), as illustrated by Ming below.

And for a device to be put to D3 hot, it should:
1 execuate _PS3 first if available
2 turn on all the power resources referenced by _PR3

And for a device to be put to D3 cold, it should:
1 execute _PS3 first if available
2 turn off power resources referenced by _PRx, where x is the previous
state number of the device. Say if the device is put to D3 cold from D0,
the x would be 0.

Is this correct?

Thank,
Aaron

> 
> Let's see an example
> 
> Assume a device "dev0" depends on 5 power resources:
> 
> pr1, pr2, pr3, pr4, pr5
> 
> _PR3 lists 3 power resources: pr3, pr4, pr5
> 
> Device(dev0)
> {
> 	Name(_PR3, Package (0x03)
> 	{
> 		pr3,
> 		pr4,
> 		pr5
> 	})
> }
> 
> If dev0 is put into ACPI D3_hot and pr1 and pr2 are not referenced by
> other devices, then it requires:
> 
> - pr1 and pr2 are off
> - pr3, pr4 and pr5 are on
> 
> right?
> 
> Thanks,
> Lin Ming
> 
> 
> 

