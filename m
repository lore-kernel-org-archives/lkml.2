Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab2KEVhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:37:20 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4858 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162Ab2KEVhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:37:18 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <5098313F.2060903@broadcom.com>
Date: Mon, 5 Nov 2012 13:35:59 -0800
From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615
 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Xi Wang" <xi.wang@gmail.com>
cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [SCSI] bnx2fc: fix NULL checking in
 bnx2fc_initiate_tmf()
References: <1352096153-18211-1-git-send-email-xi.wang@gmail.com>
In-Reply-To: <1352096153-18211-1-git-send-email-xi.wang@gmail.com>
X-WSS-ID: 7C86EEB746G20117-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2012 10:15 PM, Xi Wang wrote:
> The dereference rport->data should come after the NULL check of rport.
>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> ---
>   drivers/scsi/bnx2fc/bnx2fc_io.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 8d4626c..eebe93c 100644
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
I thought I acked similar patch sometime back, but this did not make it 
to the tree yet.

doing it again. Thanks!

Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>


