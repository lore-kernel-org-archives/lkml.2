Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab0IWP0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:26:22 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:57492 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab0IWP0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:26:20 -0400
In-Reply-To: <1285187417-10928-1-git-send-email-nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] siw: Fix ib_register_device() for > v2.6.34 kernels
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andi Keen <ak@linux.intel.com>, David Miller <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-rdma-owner@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        netdev <netdev@vger.kernel.org>, Roland Dreier <rdreier@cisco.com>,
        Matthew Wilcox <willy@linux.intel.com>
X-Mailer: Lotus Notes Release 7.0.1 January 17, 2006
Message-ID: <OF5AB6498C.AF25B239-ONC12577A7.0054B7CD-C12577A7.0054CDCD@ch.ibm.com>
From: Bernard Metzler <BMT@zurich.ibm.com>
Date: Thu, 23 Sep 2010 17:26:16 +0200
X-MIMETrack: Serialize by Router on D12MC302/12/M/IBM(Release 8.5|December 05, 2008) at
 23/09/2010 17:26:16
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Nicholas. Just applied your patch.

Bernard.

linux-rdma-owner@vger.kernel.org wrote on 09/22/2010 10:30:17 PM:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch adds a LINUX_VERSION_CODE > v2.6.34 check inside of
> siw_main.c:siw_register_device()
> around the use of ib_register_device().  In post v2.6.34 kernels
> this function accepts a second
> parameter used a sysfs port callback described here:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;
> a=commitdiff;h=9a6edb60ec10d86b1025a0cdad68fd89f1ddaf02
>
> This patch currently sets this second parameter to NULL.
>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  softiwarp/siw_main.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/softiwarp/siw_main.c b/softiwarp/siw_main.c
> index cacedea..c97adee 100644
> --- a/softiwarp/siw_main.c
> +++ b/softiwarp/siw_main.c
> @@ -233,8 +233,11 @@ int siw_register_device(struct siw_dev *dev)
>     ibdev->iwcm->add_ref = siw_qp_get_ref;
>     ibdev->iwcm->rem_ref = siw_qp_put_ref;
>     ibdev->iwcm->get_qp = siw_get_ofaqp;
> -
> +#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 34)
> +   rv = ib_register_device(ibdev, NULL);
> +#else
>     rv = ib_register_device(ibdev);
> +#endif
>     if (rv) {
>        dprint(DBG_DM|DBG_ON, "(dev=%s): "
>           "ib_register_device failed: rv=%d\n", ibdev->name, rv);
> --
> 1.5.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

