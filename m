Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab1IQRx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 13:53:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:32762 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab1IQRx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 13:53:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,398,1312182000"; 
   d="scan'208";a="54833117"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Julia Lawall <julia@diku.dk>, Greg Kroah-Hartman <gregkh@suse.de>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "Weil, Oren jer" <oren.jer.weil@intel.com>,
        "Tzeel-Krupp, Itzhak" <itzhak.tzeel-krupp@intel.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 17 Sep 2011 20:53:10 +0300
Subject: RE: [PATCH 2/4] drivers/staging/mei/interface.c: take size of
 pointed value, not pointer
Thread-Topic: [PATCH 2/4] drivers/staging/mei/interface.c: take size of
 pointed value, not pointer
Thread-Index: Acx0PfJAL72pRBpZSOGCHnxGpYx3YwBIdYCw
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401C7CA462E@hasmsx504.ger.corp.intel.com>
References: <1316156255-19509-2-git-send-email-julia@diku.dk>
In-Reply-To: <1316156255-19509-2-git-send-email-julia@diku.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Julia Lawall [mailto:julia@diku.dk]
> Sent: Friday, September 16, 2011 9:58 AM
> To: Greg Kroah-Hartman
> Cc: kernel-janitors@vger.kernel.org; Winkler, Tomas; Weil, Oren jer; Tzeel-
> Krupp, Itzhak; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 2/4] drivers/staging/mei/interface.c: take size of pointed
> value, not pointer
> 
> From: Julia Lawall <julia@diku.dk>
> 
> Sizeof a pointer-typed expression returns the size of the pointer, not that of
> the pointed data.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression *e;
> type T;
> identifier f;
> @@
> 
> f(...,(T)e,...,
> -sizeof(e)
> +sizeof(*e)
> ,...)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>

> 
> ---
>  drivers/staging/mei/interface.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -u -p a/drivers/staging/mei/interface.c b/drivers/staging/mei/interface.c
> --- a/drivers/staging/mei/interface.c
> +++ b/drivers/staging/mei/interface.c
> @@ -332,7 +332,7 @@ int mei_send_flow_control(struct mei_dev
>  	mei_hdr->reserved = 0;
> 
>  	mei_flow_control = (struct hbm_flow_control *) &dev-
> >wr_msg_buf[1];
> -	memset(mei_flow_control, 0, sizeof(mei_flow_control));
> +	memset(mei_flow_control, 0, sizeof(*mei_flow_control));
>  	mei_flow_control->host_addr = cl->host_client_id;
>  	mei_flow_control->me_addr = cl->me_client_id;
>  	mei_flow_control->cmd.cmd = MEI_FLOW_CONTROL_CMD; @@ -
> 396,7 +396,7 @@ int mei_disconnect(struct mei_device *de
> 
>  	mei_cli_disconnect =
>  	    (struct hbm_client_disconnect_request *) &dev->wr_msg_buf[1];
> -	memset(mei_cli_disconnect, 0, sizeof(mei_cli_disconnect));
> +	memset(mei_cli_disconnect, 0, sizeof(*mei_cli_disconnect));
>  	mei_cli_disconnect->host_addr = cl->host_client_id;
>  	mei_cli_disconnect->me_addr = cl->me_client_id;
>  	mei_cli_disconnect->cmd.cmd = CLIENT_DISCONNECT_REQ_CMD;

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

