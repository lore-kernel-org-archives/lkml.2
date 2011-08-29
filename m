Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab1H2Vnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:43:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48537 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab1H2Vne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:43:34 -0400
Subject: Re: [PATCH 18/24] sctp: Remove unnecessary OOM logging messages
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <21b4d996c8861373ac77d427914ec7882fe0c83e.1314650069.git.joe@perches.com>
References: <cover.1314650069.git.joe@perches.com>
	 <21b4d996c8861373ac77d427914ec7882fe0c83e.1314650069.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 23:43:28 +0200
Message-ID: <1314654209.2563.7.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 29 août 2011 à 14:17 -0700, Joe Perches a écrit :
> Removing unnecessary messages saves code and text.
> 
> Site specific OOM messages are duplications of a generic MM
> out of memory message and aren't really useful, so just
> delete them.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
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


It would be nice if you could avoid all these patches, that you dont
even read.

As I already told you in the past, __GFP_NOWARN dont print generic OOM
messages.

Its not because I told Wang Shaoyan not adding a useless "pr_err("Out of
memory\n");" in last gianfar patch, that you have to remove all
messages, with one hundred or more patches.

If I remember well, you even disagreed at that time.

Furthermore, a failed vmalloc() is not guaranteed to emit an OOM
message, is it ?



