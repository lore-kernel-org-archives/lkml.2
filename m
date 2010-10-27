Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761177Ab0J0NAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:00:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39432 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab0J0NAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:00:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=admIF3vvVJ5wleeT73DgWhzC9BR0DIZ5qwdw7wIMnBQHw0hyPRHQ7MZuXb7wAH0WuQ
         SFkRZu6ZKYbdn1ESZFRfE1j3UQGxyGQzNPUsVYWCVjYhsPgdWKsVT0VO4vB7a3qySGWr
         Th16jKD/QmEIk2wM63beYeZ8/HjGU3FpF+yc8=
Subject: Re: [PATCH] tcp: md5 signature check scaling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dmitry Popov <dp@highloadlab.com>
Cc: "David S. Miller" <davem@davemloft.net>, William.Allen.Simpson@gmail.com,
        Andreas Petlund <apetlund@simula.no>,
        Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Gilad Ben-Yossef <gilad@codefidence.com>,
        Yony Amit <yony@comsleep.com>, Zhu Yi <yi.zhu@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <AANLkTi=U1smX6XXDMyBTicyqbUU5V-t56jmH7qtX2XW5@mail.gmail.com>
References: <AANLkTi=U1smX6XXDMyBTicyqbUU5V-t56jmH7qtX2XW5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 15:00:05 +0200
Message-ID: <1288184405.2709.108.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 octobre 2010 à 16:52 +0400, Dmitry Popov a écrit :
> From: Dmitry Popov <dp@highloadlab.com>
> 
> TCP MD5 signature checking without socket lock.
> 
> Each tcp_sock has 2 RCU-protected arrays (tcp[46]_md5sig_info) of
> tcp[46]_md5sig_key address-key pairs.
> Each key (tcp_md5sig_key) has kref struct so that there is no need to
> lock the whole array to work with one key.
> 
> MD5 functions were rewritten according to above statement and hash
> check (tcp_v4_inbound_md5_hash) was moved before socket lock.
> 
> Signed-off-by: Dmitry Popov <dp@highloadlab.com>
> ---
>  include/linux/tcp.h      |   14 ++-
>  include/net/tcp.h        |   82 +++++++----
>  net/ipv4/tcp_ipv4.c      |  370 ++++++++++++++++++++++++++++------------------
>  net/ipv4/tcp_minisocks.c |   26 +--
>  net/ipv4/tcp_output.c    |   12 +-
>  net/ipv6/tcp_ipv6.c      |  358 +++++++++++++++++++++++++++-----------------
>  6 files changed, 531 insertions(+), 331 deletions(-)

This is a huge patch :(

Reading changelog, I dont understand what you did, and why you did this.

You want to avoid taking the socket lock ? But we need to take it anyway
to process packets.



