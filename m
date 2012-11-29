Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2K2GPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:15:17 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:14875 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2K2GPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:15:15 -0500
Message-ID: <50B6FD64.2080504@chelsio.com>
Date: Thu, 29 Nov 2012 11:45:00 +0530
From: Naresh Kumar Inna <naresh@chelsio.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] [SCSI] csiostor: remove unneeded memset()
References: <20121127173330.GD1059@elgon.mountain>
In-Reply-To: <20121127173330.GD1059@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.193.191.187]
X-OriginalArrivalTime: 29 Nov 2012 06:15:05.0964 (UTC) FILETIME=[E023D2C0:01CDCDF8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 11:03 PM, Dan Carpenter wrote:
> No need to memset() this when we just copy over it on the next line.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
> index 551959e..8b54976 100644
> --- a/drivers/scsi/csiostor/csio_lnode.c
> +++ b/drivers/scsi/csiostor/csio_lnode.c
> @@ -245,7 +245,6 @@ csio_append_attrib(uint8_t **ptr, uint16_t type, uint8_t *val, uint16_t len)
>  	len += 4;		/* includes attribute type and length */
>  	len = (len + 3) & ~3;	/* should be multiple of 4 bytes */
>  	ae->len = htons(len);
> -	memset(ae->value, 0, len - 4);
>  	memcpy(ae->value, val, len);
>  	*ptr += len;
>  }
> 

Acked-by: Naresh Kumar Inna <naresh@chelsio.com>

Thanks,
Naresh.

