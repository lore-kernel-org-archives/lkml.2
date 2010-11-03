Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab0KCFXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 01:23:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63674 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab0KCFXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 01:23:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YFNeM+GxvnWinwSUfG/r+RjaGKNw6QoDi96IVfRUSuoZI30gDOs8nP0vJs30V5XyPg
         4fNhnvYKj0oCvEQfYzJDaz4BvRX2NYm88nXR7NeiMcMTLoMi9VVD8Zud2Cyo4sCJZRTV
         Uz1egiGNJmMh0viEZPDW5O4r3KGq707lvfaww=
Subject: Re: [PATCH] net dst: fix percpu_counter list corruption and poison
 overwritten
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
In-Reply-To: <1288750265-17664-1-git-send-email-dfeng@redhat.com>
References: <1288750265-17664-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 06:22:53 +0100
Message-ID: <1288761773.2467.535.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 03 novembre 2010 à 10:11 +0800, Xiaotian Feng a écrit :
> There're some percpu_counter list corruption and poison overwritten warnings
> in recent kernel, which is resulted by fc66f95c.
> 
> commit fc66f95c switches to use percpu_counter, in ip6_route_net_init, kernel
> init the percpu_counter for dst entries, but, the percpu_counter is never destroyed
> in ip6_route_net_exit. So if the related data is freed by kernel, the freed percpu_counter
> is still on the list, then if we insert/remove other percpu_counter, list corruption
> resulted. Also, if the insert/remove option modifies the ->prev,->next pointer of
> the freed value, the poison overwritten is resulted then.
> 
> With the following patch, the percpu_counter list corruption and poison overwritten
> warnings disappeared.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: "Pekka Savola (ipv6)" <pekkas@netcore.fi>
> Cc: James Morris <jmorris@namei.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Patrick McHardy <kaber@trash.net>
> ---

Good catch, thanks !

Any reason you didnt Cc me (the author of the patch) ?

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



