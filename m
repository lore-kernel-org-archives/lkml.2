Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab2HRIyk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 04:54:40 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:64482 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2HRIyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 04:54:38 -0400
Date: Sat, 18 Aug 2012 17:53:37 +0900 (JST)
Message-Id: <20120818.175337.1305564732068169507.fujita.tomonori@lab.ntt.co.jp>
To: dan.carpenter@oracle.com
Cc: bprakash@broadcom.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] [SCSI] bnx2fc: zero out sense buffer properly
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20120818084637.GA30592@elgon.mountain>
References: <20120818084637.GA30592@elgon.mountain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2012 11:46:37 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> ->sense_buffer used to be an array but it changed to pointer in
> de25deb180 "[SCSI] use dynamically allocated sense buffer".  This call
> to memset() needs to be updated as well.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 73f231c..8d4626c 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1807,7 +1807,7 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
>  			fcp_sns_len = SCSI_SENSE_BUFFERSIZE;
>  		}
>  
> -		memset(sc_cmd->sense_buffer, 0, sizeof(sc_cmd->sense_buffer));
> +		memset(sc_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);

I guess that you can remove the line instead. IIRC, scsi-ml does it
for LLDs.
