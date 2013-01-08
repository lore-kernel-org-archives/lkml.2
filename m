Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab3AHOyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:54:17 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:4504 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455Ab3AHOyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:54:14 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Ariel Elior" <ariele@broadcom.com>
To: "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Eilon Greenstein" <eilong@broadcom.com>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [patch] bnx2x: NULL dereference on error in debug code
Thread-Topic: [patch] bnx2x: NULL dereference on error in debug code
Thread-Index: AQHN7aYB4QBgD6K21UChW7lSXPY8vpg/hGcQ
Date: Tue, 8 Jan 2013 14:54:04 +0000
Message-ID: <6AE768456CEC4B4A9B2248CB6B87EB3E1BCC7EBC@SJEXCHMB05.corp.ad.broadcom.com>
References: <20130108134213.GA23742@elgon.mountain>
In-Reply-To: <20130108134213.GA23742@elgon.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7CF2EDDF3Q42272100-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of Dan Carpenter
> Sent: Tuesday, January 08, 2013 3:42 PM
> To: Eilon Greenstein
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-
> janitors@vger.kernel.org
> Subject: [patch] bnx2x: NULL dereference on error in debug code
> 
> "vfop" is NULL here.  I've changed the debugging to not use it.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Only needed in linux-next.
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> index 71fcef0..3eef972 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> @@ -463,8 +463,7 @@ static int bnx2x_vfop_qdtor_cmd(struct bnx2x *bp,
>  		return bnx2x_vfop_transition(bp, vf, bnx2x_vfop_qdtor,
>  					     cmd->block);
>  	}
> -	DP(BNX2X_MSG_IOV, "VF[%d] failed to add a vfop. rc %d\n",
> -	   vf->abs_vfid, vfop->rc);
> +	DP(BNX2X_MSG_IOV, "VF[%d] failed to add a vfop.\n", vf->abs_vfid);
>  	return -ENOMEM;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

And now acking it properly.
Acked-by Ariel Elior <ariele@broadcom.com>

