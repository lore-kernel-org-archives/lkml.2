Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab0HPKtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 06:49:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59936 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab0HPKtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 06:49:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=OJRdG7HwA3DYWAnoLybXxiFmWOpVS7w+1OCuuVrtalh5bdwuFAt10wW6Rvy4WfT8F1
         Jz5NPvj9+sCXZmqd+VLfxv8oUWm9M5PtZ5UUXBxe1eVuNng8QeuU/Hlk3f1E+NyMy/JG
         28UdEnJCbRGZHX5CL14ewVvkDqXqVGNyJmtJw=
Date: Mon, 16 Aug 2010 10:48:59 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
Subject: Re: [GIT] Networking
Message-ID: <20100816104859.GA9178@ff.dom.local>
References: <20100816095325.GA8547@ff.dom.local> <1281955361.2524.35.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1281955361.2524.35.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 12:42:41PM +0200, Eric Dumazet wrote:
> Le lundi 16 ao??t 2010 ?? 09:53 +0000, Jarek Poplawski a écrit :
> > Eric Dumazet wrote:
> > > Le dimanche 15 aou^t 2010 a` 12:55 +0200, Eric Dumazet a écrit :
> > ...
> > > [PATCH] netfilter: {ip,ip6,arp}_tables: avoid lockdep false positive
> > > 
> > > After commit 24b36f019 (netfilter: {ip,ip6,arp}_tables: dont block
> > > bottom half more than necessary), lockdep can raise a warning
> > > because we attempt to lock a spinlock with BH enabled, while
> > > the same lock is usually locked by another cpu in a softirq context.
> > 
> > Btw, could you remind us how get_counters() are serialized (I guess
> > you can't have them on 2 cpus at the same time)?
> > 
> 
> get_counters() is serialized by the xt_find_table_lock() done from
> get_entries(). This use a mutex to guard against changes.
> 
> You are right that if we ever allow two concurrent "iptables -nvL"
> operations in the future (using a read lock on a rwlock instead of a
> mutex), then we must disable BH even for summing data from the other
> cpus.

OK, thanks for the explanation,

Jarek P.
