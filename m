Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab2GSTLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 15:11:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38699 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751170Ab2GSTLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 15:11:51 -0400
Message-ID: <1342725110.1988.36.camel@joe2Laptop>
Subject: Re: [PATCH] [Trivial] qib: fix an incorrect message
From: Joe Perches <joe@perches.com>
To: Betty Dall <betty.dall@hp.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, infinipath@qlogic.com, roland@kernel.org,
        sean.hefty@intel.com, hal.rosenstock@gmail.com
Date: Thu, 19 Jul 2012 12:11:50 -0700
In-Reply-To: <1342724170.28019.23.camel@ejdallLaptop>
References: <1342726459-2199-1-git-send-email-betty.dall@hp.com>
	 <1342720992.1988.24.camel@joe2Laptop>
	 <1342724170.28019.23.camel@ejdallLaptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 12:56 -0600, Betty Dall wrote:
> Thanks for the comment Joe. It looks like Roland already accepted the
> trivial change.

No worries.

> On Thu, 2012-07-19 at 11:03 -0700, Joe Perches wrote:
> > On Thu, 2012-07-19 at 13:34 -0600, Betty Dall wrote:
[]
> > > diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
> > []
> > > @@ -725,7 +725,7 @@ qib_pci_mmio_enabled(struct pci_dev *pdev)
> > >  static pci_ers_result_t
> > >  qib_pci_slot_reset(struct pci_dev *pdev)
> > >  {
> > > -	qib_devinfo(pdev, "QIB link_reset function called, ignored\n");
> > > +	qib_devinfo(pdev, "QIB slot_reset function called, ignored\n");
> > 
> > These sorts of typos can be avoided by using "%s: ", __func__
> > 
> > 	qib_devinfo(pdev, "QIB %s: called, ignored\n", __func__);
>
> You are right about using __func__. That is what I use typically too. In
> this file, none of the qib_devinfo() messages use __func__, so I stuck
> with the trivial change for consistency. I could write another patch
> that makes use of __func__ for all the appropriate qib_devinfo() calls
> (there are 4 of them.) Do you think that is a worthwhile change? BTW, I
> did review all the other qib_devinfo() calls to make sure they are using
> the correct function names, and they look good.

Thanks for checking Betty.

It's hard for me to answer, I'm not the maintainer.
Maybe Roland has a preference.

I'd probably rename qib_devinfo to qib_info or qib_pdev_info
(adding an _ before info for consistency) and change the
macro definitions removing the unnecessary do {} while (0).

Single statement macros don't need to be:

#define macro(fmt, ...)					\
	do {						\
		single_stmt(fmt, ##__VA_ARGS__);	\
	} while (0)

and are probably better as:

#define macro(fmt, ...)					\
	single_stmt(fmt, ##__VA_ARGS__)

cheers, Joe

