Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab1H2Vjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:39:35 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:24399 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab1H2Vjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:39:32 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Aug 2011 17:39:32 EDT
Message-ID: <4E5C04CD.8070902@hp.com>
Date: Mon, 29 Aug 2011 17:29:49 -0400
From: Vladislav Yasevich <vladislav.yasevich@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Sridhar Samudrala <sri@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/24] sctp: Remove unnecessary OOM logging messages
References: <cover.1314650069.git.joe@perches.com> <21b4d996c8861373ac77d427914ec7882fe0c83e.1314650069.git.joe@perches.com>
In-Reply-To: <21b4d996c8861373ac77d427914ec7882fe0c83e.1314650069.git.joe@perches.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2011 05:17 PM, Joe Perches wrote:
> Removing unnecessary messages saves code and text.
> 
> Site specific OOM messages are duplications of a generic MM
> out of memory message and aren't really useful, so just
> delete them.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>

-vlad

> ---
>  net/sctp/protocol.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 91784f4..0801444 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -1326,7 +1326,6 @@ SCTP_STATIC __init int sctp_init(void)
>  			__get_free_pages(GFP_ATOMIC|__GFP_NOWARN, order);
>  	} while (!sctp_assoc_hashtable && --order > 0);
>  	if (!sctp_assoc_hashtable) {
> -		pr_err("Failed association hash alloc\n");
>  		status = -ENOMEM;
>  		goto err_ahash_alloc;
>  	}
> @@ -1340,7 +1339,6 @@ SCTP_STATIC __init int sctp_init(void)
>  	sctp_ep_hashtable = (struct sctp_hashbucket *)
>  		kmalloc(64 * sizeof(struct sctp_hashbucket), GFP_KERNEL);
>  	if (!sctp_ep_hashtable) {
> -		pr_err("Failed endpoint_hash alloc\n");
>  		status = -ENOMEM;
>  		goto err_ehash_alloc;
>  	}
> @@ -1359,7 +1357,6 @@ SCTP_STATIC __init int sctp_init(void)
>  			__get_free_pages(GFP_ATOMIC|__GFP_NOWARN, order);
>  	} while (!sctp_port_hashtable && --order > 0);
>  	if (!sctp_port_hashtable) {
> -		pr_err("Failed bind hash alloc\n");
>  		status = -ENOMEM;
>  		goto err_bhash_alloc;
>  	}

