Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab0HPKmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 06:42:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47060 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab0HPKmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 06:42:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=noifD7MZ+pcck0vohphwsrcyQhRDnj4qHcyeIm6EX6C7kxoykvAJdo+CEF193bI3pg
         OX9F79HAvWJ698+0hMpmZlTzsDTrtaoKTvTHQnKUQPd5RWBWp72ltphqLhj4736pKKcl
         AMTUUuiEVlgLn3TAo+tD2bjAH3eKZqbi+S4Xo=
Subject: Re: [GIT] Networking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
In-Reply-To: <20100816095325.GA8547@ff.dom.local>
References: <20100816095325.GA8547@ff.dom.local>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 12:42:41 +0200
Message-ID: <1281955361.2524.35.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 août 2010 à 09:53 +0000, Jarek Poplawski a écrit :
> Eric Dumazet wrote:
> > Le dimanche 15 aou^t 2010 a` 12:55 +0200, Eric Dumazet a écrit :
> ...
> > [PATCH] netfilter: {ip,ip6,arp}_tables: avoid lockdep false positive
> > 
> > After commit 24b36f019 (netfilter: {ip,ip6,arp}_tables: dont block
> > bottom half more than necessary), lockdep can raise a warning
> > because we attempt to lock a spinlock with BH enabled, while
> > the same lock is usually locked by another cpu in a softirq context.
> 
> Btw, could you remind us how get_counters() are serialized (I guess
> you can't have them on 2 cpus at the same time)?
> 

get_counters() is serialized by the xt_find_table_lock() done from
get_entries(). This use a mutex to guard against changes.

You are right that if we ever allow two concurrent "iptables -nvL"
operations in the future (using a read lock on a rwlock instead of a
mutex), then we must disable BH even for summing data from the other
cpus.

Thanks


