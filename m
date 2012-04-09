Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab2DIVVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:21:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60923 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab2DIVVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:21:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH] ACPI: evaluate _PS3 when entering D3 Cold
Date: Mon, 9 Apr 2012 23:25:59 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Aaron Lu <aaron.lu@amd.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
References: <1333217910-29579-1-git-send-email-aaron.lu@amd.com> <201204090154.09183.rjw@sisk.pl> <1333935525.7482.7.camel@minggr>
In-Reply-To: <1333935525.7482.7.camel@minggr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204092325.59602.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 09, 2012, Lin Ming wrote:
> On Mon, 2012-04-09 at 01:54 +0200, Rafael J. Wysocki wrote:
> > On Thursday, April 05, 2012, Lin Ming wrote:
> > > On Thu, 2012-04-05 at 10:56 +0800, Aaron Lu wrote:
> > > > Hi,
> > > > 
> > > > On Thu, Apr 05, 2012 at 10:31:20AM +0800, Lin Ming wrote:
> > > > > > 
> > > > > > The only situation where a device can be put into ACPI D3_hot (which is not
> > > > > > the same as PCI D3_hot, mind you) is when:
> > > > > > 
> > > > > > (1) There is _PR3 listing some of the device's power resources as "on".
> > > > > > (2) The power resources listed by the _PR3 as "off" are turned off and the
> > > > > >     power resources listed by the _PR3 as "on" are left in the "on" state.
> > > > > 
> > > > > I don't understand item (2):
> > > > > 
> > > > > If the power resource is listed as "off", which means it's already
> > > > > turned off. Then why should it be turned off again?
> > > > 
> > > > Rafael,
> > > > I think you misunderstand the meaning of _PR3.
> > > > The _PR3 will evaluate a list of power resources, not two lists(one "on"
> > > > list and one "off" list), as illustrated by Ming below.
> > > > 
> > > > And for a device to be put to D3 hot, it should:
> > > > 1 execuate _PS3 first if available
> > > > 2 turn on all the power resources referenced by _PR3
> > > 
> > >   3 turn off all the power resources referenced by previous state
> > 
> > But leave the ones listed by _PR3 in the "on" state, you mean?
> 
> Yes.
> 
> _PR0: {r1, r2, r3, r4, r5}
> _PR3: {r4, r5}
> 
> D0: {r1, r2, r3, r4, r5} are all on
> D3 hot: {r1, r2, r3} are turned off and {r4, r5} are *left* on
> D3 cold: {r1, r2, r3, r4, r5} are all turned off
> 
> Is this correct?

Yes, that's my understanding.

> Thanks for your detail explanation.

No problem.

Thanks,
Rafael
