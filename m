Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab2DIPGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 11:06:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54735 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab2DIPGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 11:06:40 -0400
Subject: Re: [PATCH] sil3531: has no PM capability, remove support.
From: philby john <pjohn@mvista.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
In-Reply-To: <4F82F765.4010705@pobox.com>
References: <1333980849.11209.5.camel@localhost.localdomain>
	 <4F82F765.4010705@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Apr 2012 20:37:30 +0530
Message-ID: <1333984050.12301.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 2012-04-09 at 10:51 -0400, Jeff Garzik wrote:
> On 04/09/2012 10:14 AM, philby john wrote:
> > From: Philby John<pjohn@mvista.com>
> > Date: Mon, 9 Apr 2012 19:09:51 +0530
> > Subject: [PATCH] sil3531: has no PM capability, remove support.
> >
> > SATA sil3531 does not support Power Management Capability and
> > as per the manual Bit [31:27] is hardwired to 00h.
> > Otherwise, when the device goes into suspend/resume the Power
> > Management Control + Status registers are accessed and the
> > arch specific readl()/__raw_readl() calls block indefinitely.
> >
> > This patch sets the PCI_DEV_FLAGS_NO_D3 flag by which the if
> > condition in pci_set_power_state() evaluates to true and
> > pci_raw_set_power_state() functions are not executed.
> >
> > Signed-off-by: Philby John<pjohn@mvista.com>
> > Signed-off-by: Johnny Chiang<Johnny.Chiang@caviumnetworks.com>
> > ---
> >   drivers/pci/pci.c |    1 +
> >   1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index 8156744..129120d 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -1863,6 +1863,7 @@ void pci_pm_init(struct pci_dev *dev)
> >   		pci_pme_active(dev, false);
> >   	} else {
> >   		dev->pme_support = 0;
> > +		dev->dev_flags |= PCI_DEV_FLAGS_NO_D3;
> 
> This patch applies to -every- piece of PCI hardware out there, not just 
> the sil3531...
> 

But if pme_support is zero, isn't it ok to set dev_flags to
PCI_DEV_FLAGS_NO_D3 ?

Regards,
Philby


