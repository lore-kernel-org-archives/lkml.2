Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab2GJI0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 04:26:46 -0400
Received: from canardo.mork.no ([148.122.252.1]:36189 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab2GJI0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 04:26:42 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the net-next tree
Organization: m
References: <20120710130848.1014fbe05e5146a33a3c7d39@canb.auug.org.au>
Date: Tue, 10 Jul 2012 09:25:25 +0200
In-Reply-To: <20120710130848.1014fbe05e5146a33a3c7d39@canb.auug.org.au>
	(Stephen Rothwell's message of "Tue, 10 Jul 2012 13:08:48 +1000")
Message-ID: <87y5msgjru.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi all,
>
> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/net/usb/qmi_wwan.c:381:13: error: 'qmi_wwan_unbind_shared' undeclared here (not in a function)
>
> Caused by a bad automatic merge between commit 6fecd35d4cd7 ("net:
> qmi_wwan: add ZTE MF60") from the net tree and commit 230718bda1be ("net:
> qmi_wwan: bind to both control and data interface") from the net-next
> tree.
>
> I added the following merge fix patch:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 10 Jul 2012 13:06:01 +1000
> Subject: [PATCH] net: fix for qmi_wwan_unbind_shared changes
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/usb/qmi_wwan.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 06cfcc7..85c983d 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -378,7 +378,7 @@ static const struct driver_info qmi_wwan_force_int2 = {
>  	.description	= "Qualcomm WWAN/QMI device",
>  	.flags		= FLAG_WWAN,
>  	.bind		= qmi_wwan_bind_shared,
> -	.unbind		= qmi_wwan_unbind_shared,
> +	.unbind		= qmi_wwan_unbind,
>  	.manage_power	= qmi_wwan_manage_power,
>  	.data		= BIT(2), /* interface whitelist bitmap */
>  };


Looks good.  Thanks.


Bjørn
