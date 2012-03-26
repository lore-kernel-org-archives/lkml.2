Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab2CZR1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:27:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57425 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730Ab2CZR1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:27:21 -0400
Message-ID: <4F70A6F6.7080401@gmail.com>
Date: Mon, 26 Mar 2012 10:27:18 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: david.daney@cavium.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH]drivers:staging:octeon Fix typos in staging:octeon
References: <1332771969-14754-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1332771969-14754-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 07:26 AM, Justin P. Mattock wrote:
> From: "Justin P. Mattock"<justinmattock@gmail.com>
>
> The below patch fixes some typos an comments I found while reading.
>
> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>
> ---
>   drivers/staging/octeon/ethernet-rx.c   |    2 +-
>   drivers/staging/octeon/ethernet-tx.c   |   10 +++++-----
>   drivers/staging/octeon/ethernet-util.h |    2 +-
>   drivers/staging/octeon/ethernet.c      |    2 +-
>   4 files changed, 8 insertions(+), 8 deletions(-)

For the most part I am fine with this, however ...

[...]
> --- a/drivers/staging/octeon/ethernet-tx.c
> +++ b/drivers/staging/octeon/ethernet-tx.c
> @@ -61,7 +61,7 @@
>    * You can define GET_SKBUFF_QOS() to override how the skbuff output
>    * function determines which output queue is used. The default
>    * implementation always uses the base queue for the port. If, for
> - * example, you wanted to use the skb->priority fieid, define
> + * example, you wanted to use the skb->priority field, define
>    * GET_SKBUFF_QOS as: #define GET_SKBUFF_QOS(skb) ((skb)->priority)
>    */
>   #ifndef GET_SKBUFF_QOS
> @@ -164,8 +164,8 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
>   #endif
>
>   	/*
> -	 * Prefetch the private data structure.  It is larger that one
> -	 * cache line.
> +	 * Prefetch the private data structure.  If it is larger than the
> +	 * one cache line.
>   	 */

The size of the private data structure is known, and it is indeed larger 
than a single cache line. So if you are intent on fixing comments, lets 
not make this conditional and go ahead and remove that 'If'.

Thanks,
David Daney
