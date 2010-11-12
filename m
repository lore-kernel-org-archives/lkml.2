Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab0KLSNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:13:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63135 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab0KLSNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:13:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=O6Zwlo8+wa1SBIwKXvwmqZClxf4CPYrT6XJfXG8aR/MZoaepjTw/A1dw30g+FJwLy/
         NTXk/XMjAb3U+FX+oKxv4lvz5tqQg078/Hs2+4mJ96Z6SRhoWvRnS7ADEcvngD5IKad4
         pBoM9QqqZnwgmXYEGFQIOTareiZ2jCZcC+HJU=
Subject: Re: a problem tcp_v4_err()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Patrick McHardy <kaber@trash.net>, David Lamparter <equinox@diac24.net>,
        Eric Paris <eparis@redhat.com>, Hua Zhong <hzhong@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, paul.moore@hp.com
In-Reply-To: <20101112175715.GB16544@ms2.inr.ac.ru>
References: <20101111210341.31350.86916.stgit@paris.rdu.redhat.com>
	 <00c201cb81eb$84e18160$8ea48420$@com>
	 <1289578108.3083.95.camel@localhost.localdomain>
	 <1289578532.3185.265.camel@edumazet-laptop>
	 <20101112163543.GB122902@jupiter.n2.diac24.net>
	 <4CDD7145.8070606@trash.net>  <20101112175715.GB16544@ms2.inr.ac.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 19:12:58 +0100
Message-ID: <1289585578.3185.268.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 12 novembre 2010 à 20:57 +0300, Alexey Kuznetsov a écrit :
> Hello!
> 
> I looked at tcp_v4_err() and found something strange. Quite non-trivial operations
> are performed on unlocked sockets. It looks like at least this BUG_ON():
> 
>                 skb = tcp_write_queue_head(sk);
>                 BUG_ON(!skb);
> 
> can be easily triggered.
> 
> Do I miss something?
> 

Hi Alexey !

I see socket is locked around line 368,

        bh_lock_sock(sk);
        /* If too many ICMPs get dropped on busy
         * servers this needs to be solved differently.
         */
        if (sock_owned_by_user(sk))
                NET_INC_STATS_BH(net, LINUX_MIB_LOCKDROPPEDICMPS);


Hmm, maybe some goto is missing ;)



