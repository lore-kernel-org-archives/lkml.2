Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab1BAH0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 02:26:45 -0500
Received: from webmail.exar.com ([204.154.183.83]:36695 "EHLO smtp1.exar.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751293Ab1BAH0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 02:26:43 -0500
From: Ramkrishna Vepa <Ramkrishna.Vepa@exar.com>
To: Stefan Weil <weil@mail.berlios.de>
CC: Sivakumar Subramani <Sivakumar.Subramani@exar.com>,
        Sreenivasa Honnur <Sreenivasa.Honnur@exar.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Mason <Jon.Mason@exar.com>
Date: Mon, 31 Jan 2011 23:26:40 -0800
Subject: RE: [PATCH] vxge: Fix wrong boolean operator {nodisc}
Thread-Topic: [PATCH] vxge: Fix wrong boolean operator {nodisc}
Thread-Index: Acu/OvXjjJaXQDvdRs2AQ73vAGQIZgCpcJ9g
Message-ID: <FCA91A92EE52B041906A0358FC28FCC38EFBE64996@FRE1EXCH02.hq.exar.com>
References: <1296253817-7668-1-git-send-email-weil@mail.berlios.de>
In-Reply-To: <1296253817-7668-1-git-send-email-weil@mail.berlios.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This error is reported by cppcheck:
> drivers/net/vxge/vxge-config.c:3693: warning: Mutual exclusion over ||
> always evaluates to true. Did you intend to use && instead?
> 
> It looks like cppcheck is correct, so fix this. No test was run.
> 
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
> ---
>  drivers/net/vxge/vxge-config.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/vxge/vxge-config.c b/drivers/net/vxge/vxge-
> config.c
> index 01c05f5..228d4f7 100644
> --- a/drivers/net/vxge/vxge-config.c
> +++ b/drivers/net/vxge/vxge-config.c
> @@ -3690,7 +3690,7 @@ __vxge_hw_vpath_rts_table_get(struct
> __vxge_hw_vpath_handle *vp,
>  	if (status != VXGE_HW_OK)
>  		goto exit;
> 
> -	if ((rts_table != VXGE_HW_RTS_ACCESS_STEER_CTRL_DATA_STRUCT_SEL_DA)
> ||
> +	if ((rts_table != VXGE_HW_RTS_ACCESS_STEER_CTRL_DATA_STRUCT_SEL_DA)
> &&
>  	    (rts_table !=
>  	     VXGE_HW_RTS_ACS_STEER_CTRL_DATA_STRUCT_SEL_RTH_MULTI_IT))
>  		*data1 = 0;
> --
Fix looks good. Thanks!

Acked-by: Ram Vepa <ram.vepa@exar.com>
