Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab0HTP3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:29:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41141 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab0HTP33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:29:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UrbBxiWgE1r7m7TOAezL7KQNqSzMshzttIh6DcFQJlF5PcdwnE0g2l0E4OsNs/3YrL
         GJOagdbkOOZ/YXit2AUSTj8rWAm/K1gqGlUPszjrpVt9g1GSFymQHzeN67Rdet8ajVXQ
         GDP0UO7uhV7UzU2oRHTGSz5eMEVDGEgGSyoa8=
Subject: Re: [PATCH v3] netfilter: save the hash of the tuple in the
 original direction for latter use
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        akpm@linux-foundation.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimj=6HBdZK0WiPBxhm9YPG_8zRXEZyP--E7Shj8@mail.gmail.com>
References: <1282316003-2966-1-git-send-email-xiaosuo@gmail.com>
	 <1282317016.2484.173.camel@edumazet-laptop>
	 <AANLkTimj=6HBdZK0WiPBxhm9YPG_8zRXEZyP--E7Shj8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 17:29:23 +0200
Message-ID: <1282318163.2484.212.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 20 août 2010 à 23:22 +0800, Changli Gao a écrit :

> I should keep the old way, but fix a race.
> 
>         if (unlikely(!nf_conntrack_hash_rnd_initted)) {
>                 get_random_bytes(&nf_conntrack_hash_rnd,
>                                 sizeof(nf_conntrack_hash_rnd));
>                 nf_conntrack_hash_rnd_initted = 1;
>         }
> 
> nf_conntrack_alloc() isn't called with in the nf_conntrack_lock. So
> the above code maybe executed more than once on different CPUs. It is
> easy to fix with the cmpxchg() trick.

Sure, please fix the race first.

But as I said, its not critical, if one or two conntracks are hashed on
wrong basis. They will eventually disappear after timeout.



