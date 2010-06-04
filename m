Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab0FDC2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 22:28:53 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46611 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab0FDC2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 22:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=b9ushosSytx9KHy23tBLNc7yRKky9/f9L+REzJS4PrBSEVGIY42TDHD9F5cvFODoUf
         chkcikVU6zZujRHGD2GNSqGIsrk3n2qI0JQXnkSqLg+1jv91zpXT2rIFWxydERFmLP98
         2o4CuQ/UeCEVUdb7SMX+2zWqFxF2PccmehPlI=
MIME-Version: 1.0
In-Reply-To: <EA929A9653AAE14F841771FB1DE5A1365FF3FF358C@rrsmsx501.amr.corp.intel.com>
References: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com> 
	<20100601183920.GB19955@kroah.com> <EA929A9653AAE14F841771FB1DE5A1365FF3EC130E@rrsmsx501.amr.corp.intel.com> 
	<AANLkTinmxW5gQUOYJgK67Dc1FdakeXSmuu1hExKKL1qk@mail.gmail.com> 
	<EA929A9653AAE14F841771FB1DE5A1365FF3F8D431@rrsmsx501.amr.corp.intel.com> 
	<AANLkTilDY61GMGNLezXYLbbe3B8-SvgMOK5L9Q6juETL@mail.gmail.com> 
	<AANLkTilh4P9pcC53J7An3TioIPNk7LAwp9zq1R7jwiCx@mail.gmail.com> 
	<EA929A9653AAE14F841771FB1DE5A1365FF3FF358C@rrsmsx501.amr.corp.intel.com>
From: Frank Pan <frankpzh@gmail.com>
Date: Fri, 4 Jun 2010 10:28:30 +0800
Message-ID: <AANLkTinsbP04d9qlgGCx1JXIrFkb6ls-iUWduuhRq5_b@mail.gmail.com>
Subject: Re: Add a helper function in PCI IOV to get VF device
To: "Williams, Mitch A" <mitch.a.williams@intel.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Yu Zhao <yu.zhao@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Frank, I still don't understand what you're trying to do here. What's the use case? What is the end goal that you're trying to get to?
>
> What information do you need about the VF, and why?  SR-IOV works properly today without this stuff.
>
> If we can understand what you're trying to do, then maybe we can help.

Sorry, I used to think of this issue is common, but maybe not.
I'm hacking igb to add support of VF migration. Migration is emerging
as a standard of PCI IOV, but has not implemented in intel 82576(igb).
The idea is interact with VF's MMIO/PCI configuration in the physical
machine, which only PF's driver exists.

This work started by userspace. All I know is the PCI BDF of the VF,
because give BDF to the VMM is enough to assign a VF to a VM.
So here comes the first issue, neither userspace nor PF driver knows
the map from VF's ID to BDF. My plan is communicating with PF's driver
by sysfs, so I repeatly complain about the sysfs issue.
PF can access VF's BAR when it knows VF's ID. On the other hand, PF
can access VF's PCI configuration only when if knows VF's BDF. This is
the second issue. Even when userspace calculated and gave it an id, PF
driver still cannot access the PCI configuration of VF.

Really thanks for your help. I'm new on both kernel scope and English scope. :)

-- 
Frank Pan

Computer Science and Technology
Tsinghua University
