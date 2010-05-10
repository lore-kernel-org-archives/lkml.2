Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab0EJP5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 11:57:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:28739 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab0EJP5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 11:57:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QttTllYmYGKaFA399kpQmYL9Nxf+ggCsCyr4W/Lm4GPn2gxU2RKdzDF9yLeuf8QX90
         tw0DCSeP2a3p/8X11ExjIxgTV/ATMAV6juW/1X6hJtbYiLj6LhsuM3CWOeA95ucRC5ND
         62mVObQOd7FNMf7dH1FZq4j7jp1Ek04ZmIbp0=
Subject: Re: mmotm 2010-04-28 - RCU whinges
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: David Miller <davem@davemloft.net>, Valdis.Kletnieks@vt.edu,
       akpm@linux-foundation.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com
In-Reply-To: <1273506968.2221.19.camel@edumazet-laptop>
References: <1272865137.2173.179.camel@edumazet-laptop>
	 <1272865267.2173.180.camel@edumazet-laptop>
	 <1272865436.2173.182.camel@edumazet-laptop>
	 <20100502.225509.233880079.davem@davemloft.net>
	 <4BE8290A.2080707@trash.net>  <1273506968.2221.19.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 17:57:31 +0200
Message-ID: <1273507052.2221.20.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 10 mai 2010 à 17:56 +0200, Eric Dumazet a écrit :
> Le lundi 10 mai 2010 à 17:40 +0200, Patrick McHardy a écrit :
> > David Miller wrote:
> > > From: Eric Dumazet <eric.dumazet@gmail.com>
> > > Date: Mon, 03 May 2010 07:43:56 +0200
> > > 
> > >> Le lundi 03 mai 2010 à 07:41 +0200, Eric Dumazet a écrit :
> > >>
> > >>> Oops scratch that, I'll resend a correct version.
> > >>>
> > >>>
> > >> Sorry, patch _is_ fine, I had one brain collapse when re-reading it, I
> > >> thought a different mutex was in use in one of the functions.
> > > 
> > > Ok, Patrick please review, thanks.
> > 
> > Actually we don't need the rcu_dereference() calls at all since
> > registration and unregistration are protected by the mutexes.
> > 
> > I queued this patch in nf-next, the only reason why I haven't
> > submitted it yet is that I was unable to get git to cleanly export
> > only the proper set of patches meant for -next due to a few merges,
> > it insists on including 5 patches already merged upstream. If you
> > don't mind ignoring the first 5 patches in the series, I'll send a
> > pull request tonight.
> > 
> 
> 
> This will clash with upcoming RCU patches, where rcu protected pointer
> cannot be directly accessed without lockdep splats.
> 

Sorry, I meant sparse here, not lockdep.

> We will need one day or another a rcu_...(nf_conntrack_event_cb)


