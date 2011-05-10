Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab1EJVsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 17:48:42 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:53453 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1EJVsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 17:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EyDQqRdfPgy3sB6dYwYr291EYBgTz9gH8tZujY3i4WIbqKJW0fnSxrhn4Ty6bMFJ8E
         rcD6JJqefapdWz/4yiD7chsPoI9q0S8hUjCnCzMJUyWfijOlSg9P2KYznOUcrEOClx+R
         o31/tpuyQWK0EGx1mxAXSN+oH+OogayZfxJx8=
Subject: Re: 2.6.39-rc6-mmotm0506 - another lockdep splat (networking this
 time)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20110509.205851.189693332.davem@davemloft.net>
References: <6954.1304989523@localhost>
	 <1304994188.3050.17.camel@edumazet-laptop>
	 <1304999271.3050.41.camel@edumazet-laptop>
	 <20110509.205851.189693332.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 23:48:36 +0200
Message-ID: <1305064116.2437.34.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 09 mai 2011 à 20:58 -0700, David Miller a écrit :
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Tue, 10 May 2011 05:47:51 +0200
> 
> > [PATCH net-next-2.6] net: fix two lockdep splats
> > 
> > Commit e67f88dd12f6 (net: dont hold rtnl mutex during netlink dump
> > callbacks) switched rtnl protection to RCU, but we forgot to adjust two
> > rcu_dereference() lockdep annotations :
> > 
> > inet_get_link_af_size() or inet_fill_link_af() might be called with
> > rcu_read_lock or rtnl held, so use rcu_dereference_rtnl()
> > instead of rtnl_dereference()
> > 
> > Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> Applied, thanks everyone.

David, I found you applied this patch for net-2.6, but it was
net-next-2.6 material only ...



