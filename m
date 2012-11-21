Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2KUJFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:05:12 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46601 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab2KUJFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:05:08 -0500
Date: Wed, 21 Nov 2012 12:04:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johan Meiring <johanmeiring@gmail.com>
Cc: gregkh@linuxfoundation.org, a.beregalov@gmail.com, devendra.aaru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] staging: cxt1e1: sbecrc.c: fixes 80+ char line
 length issue
Message-ID: <20121121090452.GE11248@mwanda>
References: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
 <1353432532-21203-10-git-send-email-johanmeiring@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353432532-21203-10-git-send-email-johanmeiring@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 07:28:52PM +0200, Johan Meiring wrote:
> This commit sorts out a single case where a line was longer than
> 80 characters.
> 
> Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
> ---
>  drivers/staging/cxt1e1/sbecrc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/cxt1e1/sbecrc.c b/drivers/staging/cxt1e1/sbecrc.c
> index 87512a5..59dd7e2 100644
> --- a/drivers/staging/cxt1e1/sbecrc.c
> +++ b/drivers/staging/cxt1e1/sbecrc.c
> @@ -101,7 +101,8 @@ sbeCrc(u_int8_t *buffer,          /* data buffer to crc */
>  		tbl = &CRCTable;
>  		genCrcTable(tbl);
>  #else
> -		tbl = (u_int32_t *) OS_kmalloc(CRC_TABLE_ENTRIES * sizeof(u_int32_t));
> +		tbl = (u_int32_t *) OS_kmalloc(CRC_TABLE_ENTRIES
> +			* sizeof(u_int32_t));

The way we would normally break this is:

		tbl = (u_int32_t *)OS_kmalloc(CRC_TABLE_ENTRIES *
					      sizeof(u_int32_t));

* goes on the first line so that it shows this is a partial line.
The sizeof() lines up with the first parameter.  You will have to
use spaces since it's not exactly on a tab stop.

But really it's better to just get rid of the call to OS_kmalloc().

		tbl = kmalloc(CRC_TABLE_ENTRIES * sizeof(*tbl), GFP_KERNEL);

OS_kmalloc() adds a GFP_DMA flag and a memset() but it's not needed
here.

regards,
dan carpenter

