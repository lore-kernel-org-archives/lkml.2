Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0EaNoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:44:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57771 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab0EaNoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:44:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kPkjQ/DIGpvhj6gLN+Ch6oaZaTM1MJQQD1WuSSOU2rnthQRwaX/NagSpon+j1n2U2c
         y//z/XvuPEwTIBFvnbn+w34b9PhT2QBGnqJAFT+ztgcLE9U96fqYNElnYSdO0z+Snuxs
         6GWkRydkBaTRJlAKjKz0YyvuZNZNWZ9X7RV5Y=
Subject: Re: [PATCH] netfilter: xtables: stackptr should be percpu
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Xiaotian Feng <dfeng@redhat.com>, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, coreteam@netfilter.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <alpine.LSU.2.01.1005311519340.25402@obet.zrqbmnf.qr>
References: <1275303998-2435-1-git-send-email-dfeng@redhat.com>
	 <alpine.LSU.2.01.1005311350580.31799@obet.zrqbmnf.qr>
	 <1275311580.3291.44.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1005311519340.25402@obet.zrqbmnf.qr>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 15:44:08 +0200
Message-ID: <1275313448.3291.49.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 31 mai 2010 à 15:22 +0200, Jan Engelhardt a écrit :
> On Monday 2010-05-31 15:13, Eric Dumazet wrote:
> >
> >All cpus share a single cache line for their 'stackptr' storage,
> >introduced in commit f3c5c1bfd4
> >
> >This is a stable candidate (2.6.34)
> 
> Stackptr was first introduced for 2.6.35-rcX.
> 

Indeed, I was fooled by 'git describe'

> >+	i->stackptr = alloc_percpu(unsigned int);
> > 	if (i->stackptr == NULL)
> > 		return -ENOMEM;
> >-	memset(i->stackptr, 0, size);
> > 
> > 	size = sizeof(void **) * nr_cpu_ids;
> > 	if (size > PAGE_SIZE)
> 
> Are alloc_percpu areas cleared?
> 

Yes, allocated chunks are cleared.


