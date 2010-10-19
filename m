Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab0JSOYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:24:49 -0400
Received: from mx04.teleca.com ([212.92.145.6]:59685 "EHLO mx04.teleca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab0JSOYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:24:48 -0400
X-Greylist: delayed 694 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2010 10:24:48 EDT
Message-ID: <4CBDA843.7030809@nokia.com>
Date: Tue, 19 Oct 2010 18:16:35 +0400
From: Roman Borisov <ext-roman.borisov@nokia.com>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org
Subject: Re: [PATCH] nfs: fix unchecked value
References: <a4f05d53b0912562f2950958831579f14c60dbb8.1286973348.git.ext-roman.borisov@nokia.com>
In-Reply-To: <a4f05d53b0912562f2950958831579f14c60dbb8.1286973348.git.ext-roman.borisov@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2010 14:13:11.0097 (UTC) FILETIME=[C2E8C290:01CB6F97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2010 04:54 PM, Roman Borisov wrote:
> Return value of "decode_attr_bitmap()" was not checked;
>
> Signed-off-by: Roman Borisov<ext-roman.borisov@nokia.com>
> ---
>   fs/nfs/nfs4xdr.c |    5 ++++-
>   1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
> index 6ea5c93..9e9cb40 100644
> --- a/fs/nfs/nfs4xdr.c
> +++ b/fs/nfs/nfs4xdr.c
> @@ -2676,7 +2676,10 @@ out_overflow:
>   static int decode_attr_supported(struct xdr_stream *xdr, uint32_t *bitmap, uint32_t *bitmask)
>   {
>   	if (likely(bitmap[0]&  FATTR4_WORD0_SUPPORTED_ATTRS)) {
> -		decode_attr_bitmap(xdr, bitmask);
> +		int ret;
> +		ret = decode_attr_bitmap(xdr, bitmask);
> +		if (unlikely(ret<  0))
> +			return ret;
>   		bitmap[0]&= ~FATTR4_WORD0_SUPPORTED_ATTRS;
>   	} else
>   		bitmask[0] = bitmask[1] = 0;

Reviewed-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Hello,

could you please review the patch and send the comments if any

Thanks,
Roman Borisov
