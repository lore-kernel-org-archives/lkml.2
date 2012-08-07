Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab2HGSiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:38:52 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:12392 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2HGSiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:38:51 -0400
Date: Tue, 7 Aug 2012 20:38:49 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>,
        Antonio Quartulli <ordex@autistici.org>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Marek Lindner <lindner_marek@yahoo.de>
Subject: Re: [PATCH] batman-adv: Fix mem leak in the batadv_tt_local_event()
 function
In-Reply-To: <alpine.LNX.2.00.1208072030500.3227@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1208072037380.3227@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1208072030500.3227@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2012, Jesper Juhl wrote:

> Memory is allocated for 'tt_change_node' with kmalloc().
> 'tt_change_node' may go out of scope really being used for anything

This should of course read "... go out of scope without really being used ..." .

> (except have a few members initialized) if we hit the 'del:' label.
> This patch makes sure we free the memory in that case.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  net/batman-adv/translation-table.c | 1 +
>  1 file changed, 1 insertion(+)
> 
>  Compile tested only.
> 
> diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
> index a438f4b..99dd8f7 100644
> --- a/net/batman-adv/translation-table.c
> +++ b/net/batman-adv/translation-table.c
> @@ -197,6 +197,7 @@ static void batadv_tt_local_event(struct batadv_priv *bat_priv,
>  del:
>  		list_del(&entry->list);
>  		kfree(entry);
> +		kfree(tt_change_node);
>  		event_removed = true;
>  		goto unlock;
>  	}
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

