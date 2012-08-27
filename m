Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab2H0Otb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 10:49:31 -0400
Received: from mxout1.idt.com ([157.165.5.25]:34613 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab2H0Ot2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 10:49:28 -0400
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Matt Porter <mporter@kernel.crashing.org>
Subject: RE: [PATCH] rapidio/tsi721: modify mport name assignment
Thread-Topic: [PATCH] rapidio/tsi721: modify mport name assignment
Thread-Index: AQHNf6i8OqccajbvQEe870vFjkB2a5dp7ZKAgAPKACA=
Date: Mon, 27 Aug 2012 14:49:17 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D12E7C2D00@corpmail1.na.ads.idt.com>
References: <1345559035-25879-1-git-send-email-alexandre.bounine@idt.com>
 <20120824140229.20e6a46c.akpm@linux-foundation.org>
In-Reply-To: <20120824140229.20e6a46c.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 24, 2012 5:02 PM
Andrew Morton <akpm@linux-foundation.org>
> 
> On Tue, 21 Aug 2012 10:23:54 -0400
> Alexandre Bounine <alexandre.bounine@idt.com> wrote:
> 
>> Modify mport device name assignment to provide clear reference to devices
>> in systems with multiple Tsi721 bridges.
>>
>> This patch is applicable to kernel versions starting from v3.2.
> 
> This seems to imply that you think the patch should be backported into
> earlier kernels.  But no reason for doing this was provided.

We cannot prevent users of earlier versions from using more than one Tsi721
device in their systems. In that case the old name form will not provide
definitive reference to a particular mport. Please, see comment below.

> 
> > --- a/drivers/rapidio/devices/tsi721.c
> > +++ b/drivers/rapidio/devices/tsi721.c
> > @@ -2165,7 +2165,8 @@ static int __devinit tsi721_setup_mport(struct
> tsi721_device *priv)
> >  	rio_init_dbell_res(&mport->riores[RIO_DOORBELL_RESOURCE], 0,
> 0xffff);
> >  	rio_init_mbox_res(&mport->riores[RIO_INB_MBOX_RESOURCE], 0, 3);
> >  	rio_init_mbox_res(&mport->riores[RIO_OUTB_MBOX_RESOURCE], 0, 3);
> > -	strcpy(mport->name, "Tsi721 mport");
> > +	snprintf(mport->name, RIO_MAX_MPORT_NAME, "%s(%s)",
> > +		 dev_driver_string(&pdev->dev), dev_name(&pdev->dev));
> 
> And it's a non-back-compatible change to a userspace-visible interface!
> As such we'd need extraordinary justification to merge it into
> *future* kernels, let alone backport it.

An mport device do not provide a userspace-visible interface at this point.
This name is used internally in RapidIO subsystem for resource tracking and
debugging. For Tsi721 as a PCIe peripheral, having the mport name that may be
easily associated with its PCIe base helps with tracking of assigned PCIe
resources. This option looks to me better than adding simple indexing
component into existing name format, especially for systems that use add-on
cards with PCIe-to-SRIO bridges.

> 
> Please, do provide much better changelogging than this.

Modify RapidIO mport device name assignment to include device name of PCIe
side of Tsi721 bridge. The new name format is intended to provide definitive
reference between RapidIO and PCIe sides of the bridge in systems with
multiple Tsi721 bridges.


