Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab2GPOBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 10:01:05 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:54362 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753587Ab2GPOBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 10:01:04 -0400
Message-ID: <1342447259.2523.9.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH] net-next: make sock diag per-namespace
From: Ben Hutchings <bhutchings@solarflare.com>
To: Andrew Vagin <avagin@openvz.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Pavel Emelyanov <xemul@parallels.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Date: Mon, 16 Jul 2012 15:00:59 +0100
In-Reply-To: <1342440849-1757320-1-git-send-email-avagin@openvz.org>
References: <1342440849-1757320-1-git-send-email-avagin@openvz.org>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 16:14 +0400, Andrew Vagin wrote:
> Before this patch sock_diag works for init_net only and dumps
> information about sockets from all namespaces.
> 
> This patch expands sock_diag for all name-spaces.
> It creates a netlink kernel socket for each netns and filters
> data during dumping.
[...]
> --- a/net/core/sock_diag.c
> +++ b/net/core/sock_diag.c
> @@ -166,23 +166,39 @@ static void sock_diag_rcv(struct sk_buff *skb)
>  	mutex_unlock(&sock_diag_mutex);
>  }
>  
> -struct sock *sock_diag_nlsk;
> -EXPORT_SYMBOL_GPL(sock_diag_nlsk);
> +struct sock *diag_nlsk;
> +EXPORT_SYMBOL_GPL(diag_nlsk);
[...]

This new variable seems to be unused.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

