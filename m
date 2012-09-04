Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab2IDBVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 21:21:51 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1245 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab2IDBVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 21:21:50 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <504557A5.1040500@broadcom.com>
Date: Mon, 3 Sep 2012 18:21:41 -0700
From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713
 Thunderbird/14.0
MIME-Version: 1.0
To: "Andi Kleen" <andi@firstfloor.org>
cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James Bottomley" <jbottomley@parallels.com>
Subject: Re: [PATCH] Fix incorrect memset in bnx2fc_parse_fcp_rsp
References: <20120903185030.GV16230@one.firstfloor.org>
In-Reply-To: <20120903185030.GV16230@one.firstfloor.org>
X-WSS-ID: 7C5B88AF49826657601-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/2012 11:50 AM, Andi Kleen wrote:
> gcc 4.8 warns because the memset only clears sizeof(char *) bytes, not
> the whole buffer. Use the correct buffer size and clear the whole sense
> buffer.
>
> /backup/lsrc/git/linux-lto-2.6/drivers/scsi/bnx2fc/bnx2fc_io.c: In
> function 'bnx2fc_parse_fcp_rsp':
> /backup/lsrc/git/linux-lto-2.6/drivers/scsi/bnx2fc/bnx2fc_io.c:1810:41:
> warning: argument to 'sizeof' in 'memset' call is the same expression as
> the destination; did you mean to provide an explicit length?
> [-Wsizeof-pointer-memaccess]
>     memset(sc_cmd->sense_buffer, 0, sizeof(sc_cmd->sense_buffer));
>                                           ^
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
>
>
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 73f231c..8d4626c 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1807,7 +1807,7 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
>   			fcp_sns_len = SCSI_SENSE_BUFFERSIZE;
>   		}
>
> -		memset(sc_cmd->sense_buffer, 0, sizeof(sc_cmd->sense_buffer));
> +		memset(sc_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
>   		if (fcp_sns_len)
>   			memcpy(sc_cmd->sense_buffer, rq_data, fcp_sns_len);
>
>
Thanks Andi. Looks good to me.

Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>


