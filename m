Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab1KBRxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:53:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33370 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab1KBRxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:53:36 -0400
Message-ID: <1320256412.2292.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Linux 3.1-rc9
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Simon Kirby <sim@hostway.ca>,
        David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Network Development <netdev@vger.kernel.org>
Date: Wed, 02 Nov 2011 18:53:32 +0100
In-Reply-To: <CA+55aFxKtA0XXtiKgKC5qHmFuTv2=TbuMEczkegJKY4Uy00a-g@mail.gmail.com>
References: <1318874090.4172.84.camel@twins>
	 <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com>
	 <1318879396.4172.92.camel@twins> <alpine.LFD.2.02.1110172237030.3240@ionos>
	 <alpine.LFD.2.02.1110181037120.3240@ionos> <1318928713.21167.4.camel@twins>
	 <20111018182046.GF1309@hostway.ca>
	 <alpine.LFD.2.02.1110182146440.3240@ionos>
	 <20111024190203.GA24410@hostway.ca> <20111025202049.GB25043@hostway.ca>
	 <20111031173246.GA10614@hostway.ca>
	 <alpine.LFD.2.02.1111021725550.2829@ionos>
	 <1320254854.2292.14.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFxKtA0XXtiKgKC5qHmFuTv2=TbuMEczkegJKY4Uy00a-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 02 novembre 2011 à 10:46 -0700, Linus Torvalds a écrit :
> On Wed, Nov 2, 2011 at 10:27 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > I believe it might come from commit 0e734419
> > (ipv4: Use inet_csk_route_child_sock() in DCCP and TCP.)
> >
> > In case inet_csk_route_child_sock() returns NULL, we dont release socket
> > lock.
> 
> Hmm. I'm not seeing it. We're not even taking the socket lock there.
> Or is it hidden somehow?
> 
>                     Linus

tcp_v4_syn_recv_sock()
{
	newsk = tcp_create_openreq_child(sk, req, skb);

...
	

}

newsk is locked at this point.



