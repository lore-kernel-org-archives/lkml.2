Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0GESn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 14:43:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60286 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab0GESn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 14:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=H1VI75LNOM/JKskBFROJJvma2gcO7L8vRkejszzb6Q1ON+xfhRgxRjrAAiN0m96d1q
         JLBNWoZkzPRAFmllPTOQhzBXvJTIkIrUGBfG5gfYwmMwVgF5ylCSJvk2CF2IgpJkLqld
         YWZ812iGeJQFp8vjv3yVEa1oDaq6z0uwcqkVo=
Message-ID: <4C3227CA.8000600@garzik.org>
Date: Mon, 05 Jul 2010 14:43:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: remove unused REQ_TYPE_LINUX_BLOCK
References: <20100705181100B.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100705181100B.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 05:11 AM, FUJITA Tomonori wrote:
> You prefer to keep this for future possible users?
>
> This can be applied to block's for-2.6.36.
>
> =
> From: FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] block: remove unused REQ_TYPE_LINUX_BLOCK
>
> Nobody uses REQ_TYPE_LINUX_BLOCK (and its REQ_LB_OP_*).
>
> Signed-off-by: FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>
> ---
>   include/linux/blkdev.h |   15 ---------------
>   1 files changed, 0 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 3a2c5d9..baf5258 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -60,7 +60,6 @@ enum rq_cmd_type_bits {
>   	REQ_TYPE_PM_RESUME,		/* resume request */
>   	REQ_TYPE_PM_SHUTDOWN,		/* shutdown request */
>   	REQ_TYPE_SPECIAL,		/* driver defined type */
> -	REQ_TYPE_LINUX_BLOCK,		/* generic block layer message */
>   	/*
>   	 * for ATA/ATAPI devices. this really doesn't belong here, ide should
>   	 * use REQ_TYPE_SPECIAL and use rq->cmd[0] with the range of driver
> @@ -70,20 +69,6 @@ enum rq_cmd_type_bits {
>   	REQ_TYPE_ATA_PC,
>   };
>
> -/*
> - * For request of type REQ_TYPE_LINUX_BLOCK, rq->cmd[0] is the opcode being
> - * sent down (similar to how REQ_TYPE_BLOCK_PC means that ->cmd[] holds a
> - * SCSI cdb.
> - *
> - * 0x00 ->  0x3f are driver private, to be used for whatever purpose they need,
> - * typically to differentiate REQ_TYPE_SPECIAL requests.
> - *
> - */
> -enum {
> -	REQ_LB_OP_EJECT	= 0x40,		/* eject request */
> -	REQ_LB_OP_FLUSH = 0x41,		/* flush request */
> -};

Acked-by: Jeff Garzik <jgarzik@redhat.com>

Having a second level of opcodes, under REQ_TYPE_LINUX_BLOCK, always 
seems less desirable than the current course of action you are now 
pursuing (REQ_FLUSH, etc.)...   nice cleanup.

	Jeff




