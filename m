Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1FTHmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 03:42:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:21937 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab1FTHl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 03:41:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,392,1304319600"; 
   d="scan'208";a="15429852"
Message-ID: <4DFEF9B6.7000402@intel.com>
Date: Mon, 20 Jun 2011 10:41:42 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: [PATCH reRESEND] block: add REQ_SECURE to REQ_COMMON_MASK
References: <1308278608-3284-1-git-send-email-namhyung@gmail.com> <1308280320-3510-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1308280320-3510-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/06/11 06:12, Namhyung Kim wrote:
> Add REQ_SECURE flag to REQ_COMMON_MASK so that
> init_request_from_bio() can pass it to @req->cmd_flags.
>
> Signed-off-by: Namhyung Kim<namhyung@gmail.com>
> ---
> Send it again due to Adrian's mail delivery failure.
>
>   include/linux/blk_types.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 2a7cea53ca0d..6395692b2e7a 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -167,7 +167,7 @@ enum rq_flag_bits {
>   	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
>   #define REQ_COMMON_MASK \
>   	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_DISCARD | \
> -	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
> +	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
>   #define REQ_CLONE_MASK		REQ_COMMON_MASK
>
>   #define REQ_RAHEAD		(1<<  __REQ_RAHEAD)

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

The fix needs to go back to 2.6.36
