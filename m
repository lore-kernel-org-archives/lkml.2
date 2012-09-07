Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab2IGSYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:24:10 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3772 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab2IGSYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:24:07 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <504A3BBF.5030604@broadcom.com>
Date: Fri, 7 Sep 2012 11:23:59 -0700
From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120824
 Thunderbird/15.0
MIME-Version: 1.0
To: "Julia Lawall" <Julia.Lawall@lip6.fr>
cc: kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/scsi/bnx2fc/bnx2fc_io.c: Remove
 potential NULL dereference
References: <1344959388-19719-1-git-send-email-Julia.Lawall@lip6.fr>
 <1344959388-19719-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1344959388-19719-3-git-send-email-Julia.Lawall@lip6.fr>
X-WSS-ID: 7C54E4E63NK24903258-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/2012 8:49 AM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> If the NULL test is necessary, the initialization involving a dereference of
> the tested value should be moved after the NULL test.
>
> The sematic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> type T;
> expression E;
> identifier i,fld;
> statement S;
> @@
>
> - T i = E->fld;
> + T i;
>    ... when != E
>        when != i
>    if (E == NULL) S
> + i = E->fld;
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>   drivers/scsi/bnx2fc/bnx2fc_io.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 73f231c..1dd82db 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -686,7 +686,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
>   {
>   	struct fc_lport *lport;
>   	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
> -	struct fc_rport_libfc_priv *rp = rport->dd_data;
> +	struct fc_rport_libfc_priv *rp;
>   	struct fcoe_port *port;
>   	struct bnx2fc_interface *interface;
>   	struct bnx2fc_rport *tgt;
> @@ -712,6 +712,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
>   		rc = FAILED;
>   		goto tmf_err;
>   	}
> +	rp = rport->dd_data;
>
>   	rc = fc_block_scsi_eh(sc_cmd);
>   	if (rc)
>
>
Thanks Julia.

Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>


