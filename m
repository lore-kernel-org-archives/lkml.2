Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1KZKyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 05:54:49 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51938 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab1KZKyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 05:54:45 -0500
Subject: Re: [BUG] 3.2-rc2: BUG kmalloc-8: Redzone overwritten
From: Sasha Levin <levinsasha928@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, Matt Mackall <mpm@selenic.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <1321870967.8173.1.camel@lappy>
References: <1321866845.3831.7.camel@lappy>
	 <1321870529.2552.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1321870915.2552.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1321870967.8173.1.camel@lappy>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sat, 26 Nov 2011 12:54:38 +0200
Message-ID: <1322304878.28191.1.camel@sasha>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 12:22 +0200, Sasha Levin wrote:
> On Mon, 2011-11-21 at 11:21 +0100, Eric Dumazet wrote:
> > Le lundi 21 novembre 2011 à 11:15 +0100, Eric Dumazet a écrit :
> > 
> > > 
> > > Hmm, trinity tries to crash decnet ;)
> > > 
> > > Maybe we should remove this decnet stuff for good instead of tracking
> > > all bugs just for the record. Is there anybody still using decnet ?
> > > 
> > > For example dn_start_slow_timer() starts a timer without holding a
> > > reference on struct sock, this is highly suspect.
> > > 
> > > [PATCH] decnet: proper socket refcounting
> > > 
> > > Better use sk_reset_timer() / sk_stop_timer() helpers to make sure we
> > > dont access already freed/reused memory later.
> > > 
> > > Reported-by: Sasha Levin <levinsasha928@gmail.com>
> > > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > 
> > Hmm, I forgot to remove the sock_hold(sk) call from dn_slow_timer(),
> > here is V2 :
> > 
> > [PATCH] decnet: proper socket refcounting
> > 
> > Better use sk_reset_timer() / sk_stop_timer() helpers to make sure we
> > dont access already freed/reused memory later.
> > 
> > Reported-by: Sasha Levin <levinsasha928@gmail.com>
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > ---
> 
> [snip]
> 
> Applied locally and running same tests as before, will update with
> results.
> 

Looks ok after a couple days of testing.

	Tested-by: Sasha Levin <levinsasha928@gmail.com>

-- 

Sasha.

