Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab2DIBit (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 21:38:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:48991 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab2DIBis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 21:38:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="126730524"
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
From: Lin Ming <ming.m.lin@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lu@amd.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
In-Reply-To: <201204090154.09183.rjw@sisk.pl>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com>
	 <20120405025609.GA5208@localhost.amd.com>
	 <1333594904.11327.27.camel@minggr>  <201204090154.09183.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Apr 2012 09:38:45 +0800
Message-ID: <1333935525.7482.7.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-09 at 01:54 +0200, Rafael J. Wysocki wrote:
> On Thursday, April 05, 2012, Lin Ming wrote:
> > On Thu, 2012-04-05 at 10:56 +0800, Aaron Lu wrote:
> > > Hi,
> > > 
> > > On Thu, Apr 05, 2012 at 10:31:20AM +0800, Lin Ming wrote:
> > > > > 
> > > > > The only situation where a device can be put into ACPI D3_hot (which is not
> > > > > the same as PCI D3_hot, mind you) is when:
> > > > > 
> > > > > (1) There is _PR3 listing some of the device's power resources as "on".
> > > > > (2) The power resources listed by the _PR3 as "off" are turned off and the
> > > > >     power resources listed by the _PR3 as "on" are left in the "on" state.
> > > > 
> > > > I don't understand item (2):
> > > > 
> > > > If the power resource is listed as "off", which means it's already
> > > > turned off. Then why should it be turned off again?
> > > 
> > > Rafael,
> > > I think you misunderstand the meaning of _PR3.
> > > The _PR3 will evaluate a list of power resources, not two lists(one "on"
> > > list and one "off" list), as illustrated by Ming below.
> > > 
> > > And for a device to be put to D3 hot, it should:
> > > 1 execuate _PS3 first if available
> > > 2 turn on all the power resources referenced by _PR3
> > 
> >   3 turn off all the power resources referenced by previous state
> 
> But leave the ones listed by _PR3 in the "on" state, you mean?

Yes.

_PR0: {r1, r2, r3, r4, r5}
_PR3: {r4, r5}

D0: {r1, r2, r3, r4, r5} are all on
D3 hot: {r1, r2, r3} are turned off and {r4, r5} are *left* on
D3 cold: {r1, r2, r3, r4, r5} are all turned off

Is this correct?

Thanks for your detail explanation.

> 
> Rafael


