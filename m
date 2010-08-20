Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0HTPKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:10:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37604 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab0HTPKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:10:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=O/y3UMpmYQeggLN2G9uGWxCdcXYwQTBo46LWBlmkzunlht/tOwSbJyxqFvBDLF9lvQ
         Six3HaFTp272YW5FuioClJUC0PIzxCZ7KmFg4o6mDhsdGq/PTAZ6RW5YNgc4VkjQqXau
         vJaAZHYyJi89xxaLRXZj05Vc3wUPEjgRM509w=
Subject: Re: [PATCH v3] netfilter: save the hash of the tuple in the
 original direction for latter use
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        akpm@linux-foundation.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1282316003-2966-1-git-send-email-xiaosuo@gmail.com>
References: <1282316003-2966-1-git-send-email-xiaosuo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 17:10:16 +0200
Message-ID: <1282317016.2484.173.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 20 août 2010 à 22:53 +0800, Changli Gao a écrit :
> Since we don't change the tuple in the original direction, we can save it
> in ct->tuplehash[IP_CT_DIR_REPLY].hnode.pprev for __nf_conntrack_confirm()
> use.
> 
> __hash_conntrack() is split into two steps: ____hash_conntrack() is used
> to get the raw hash, and __hash_bucket() is used to get the bucket id.
> 
> In SYN-flood case, early_drop() doesn't need to recompute the hash again.
> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ---

Hmm... so to accept a few more SYN packets per second in SYNFLOOD
attack, we slow a bit normal operations ? (adding one test on each
packet going through conntrack)

If yes (I dont think we should, hackers are stronger than you anyway,
just face it)

v4:
	__read_mostly on nf_conntrack_rnd


What would happen if we let the initialization of nf_conntrack_rnd
only in the insertion case (like currently done) ? 
Only the first packet received on the machine/conntrack might be hashed
on a wrong slot. Is it a big deal ? If yes, maybe find a way to
recompute the hash in this case, instead of reusing 'wrong' one ?



