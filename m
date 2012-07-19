Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2GSS4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:56:17 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:47882 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2GSS4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:56:13 -0400
Message-ID: <1342724170.28019.23.camel@ejdallLaptop>
Subject: Re: [PATCH] [Trivial] qib: fix an incorrect message
From: Betty Dall <betty.dall@hp.com>
To: Joe Perches <joe@perches.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, infinipath@qlogic.com, roland@kernel.org,
        sean.hefty@intel.com, hal.rosenstock@gmail.com
Date: Thu, 19 Jul 2012 12:56:10 -0600
In-Reply-To: <1342720992.1988.24.camel@joe2Laptop>
References: <1342726459-2199-1-git-send-email-betty.dall@hp.com>
	 <1342720992.1988.24.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Thanks for the comment Joe. It looks like Roland already accepted the
trivial change.

On Thu, 2012-07-19 at 11:03 -0700, Joe Perches wrote:
> On Thu, 2012-07-19 at 13:34 -0600, Betty Dall wrote:
> > There is a cut and paste typo in the function qib_pci_slot_reset() where
> > it prints that the "link_reset" function is called rather than the
> > "slot_reset" function. This makes the message misleading.
> 
> Hi Betty.
> 
> > diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
> []
> > @@ -725,7 +725,7 @@ qib_pci_mmio_enabled(struct pci_dev *pdev)
> >  static pci_ers_result_t
> >  qib_pci_slot_reset(struct pci_dev *pdev)
> >  {
> > -	qib_devinfo(pdev, "QIB link_reset function called, ignored\n");
> > +	qib_devinfo(pdev, "QIB slot_reset function called, ignored\n");
> 
> These sorts of typos can be avoided by using "%s: ", __func__
> 
> 	qib_devinfo(pdev, "QIB %s: called, ignored\n", __func__);


You are right about using __func__. That is what I use typically too. In
this file, none of the qib_devinfo() messages use __func__, so I stuck
with the trivial change for consistency. I could write another patch
that makes use of __func__ for all the appropriate qib_devinfo() calls
(there are 4 of them.) Do you think that is a worthwhile change? BTW, I
did review all the other qib_devinfo() calls to make sure they are using
the correct function names, and they look good.

-Betty


