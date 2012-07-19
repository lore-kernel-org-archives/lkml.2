Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab2GSSDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:03:16 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56201 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751185Ab2GSSDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:03:14 -0400
Message-ID: <1342720992.1988.24.camel@joe2Laptop>
Subject: Re: [PATCH] [Trivial] qib: fix an incorrect message
From: Joe Perches <joe@perches.com>
To: Betty Dall <betty.dall@hp.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, infinipath@qlogic.com, roland@kernel.org,
        sean.hefty@intel.com, hal.rosenstock@gmail.com
Date: Thu, 19 Jul 2012 11:03:12 -0700
In-Reply-To: <1342726459-2199-1-git-send-email-betty.dall@hp.com>
References: <1342726459-2199-1-git-send-email-betty.dall@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 13:34 -0600, Betty Dall wrote:
> There is a cut and paste typo in the function qib_pci_slot_reset() where
> it prints that the "link_reset" function is called rather than the
> "slot_reset" function. This makes the message misleading.

Hi Betty.

> diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
[]
> @@ -725,7 +725,7 @@ qib_pci_mmio_enabled(struct pci_dev *pdev)
>  static pci_ers_result_t
>  qib_pci_slot_reset(struct pci_dev *pdev)
>  {
> -	qib_devinfo(pdev, "QIB link_reset function called, ignored\n");
> +	qib_devinfo(pdev, "QIB slot_reset function called, ignored\n");

These sorts of typos can be avoided by using "%s: ", __func__

	qib_devinfo(pdev, "QIB %s: called, ignored\n", __func__);

cheers, Joe

