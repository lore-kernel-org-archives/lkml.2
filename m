Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab2F2PIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:08:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49406 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2F2PIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:08:49 -0400
Subject: Re: [RFC] [TCP 0/3] Receive from socket into bio without copying
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andreas Gruenbacher <agruen@linbit.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1340981632.25226.2.camel@gurkel.linbit>
References: <1340981632.25226.2.camel@gurkel.linbit>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jun 2012 17:08:43 +0200
Message-ID: <1340982523.21162.1.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 16:53 +0200, Andreas Gruenbacher wrote:
> Hello,
> 
> I'm (still) trying to pass data from the network to the block layer without
> copying. The block layer needs blocks to be contiguous in memory, and may have
> some alignment restrictions as well.  A lot of modern network hardware will
> receive large packets into separate buffers, so individual large packets will
> end up in contiguous, aligned buffers.  I would like to make use of that, but
> tcp currently doesn't allow me to control what ends up in which packets.
> 
> This patch series introduces a new flag for indicating to tcp when it should
> start a new segment. Using that on the sender side, I can get data over the
> network with no cpu copying at all.
> 
> [My last posting on this topic from May 8 is archived here:
>  http://www.spinics.net/lists/netdev/msg197788.html ]
> 
> Thanks,
> Andreas
> 
> Andreas Gruenbacher (3):
>   tcp: Add MSG_NEW_PACKET flag to indicate preferable packet boundaries
>   tcp: Zero-copy receive from a socket into a bio
>   fs: Export bio_release_pages()

This looks like yet another zero copy, needing another couple of hundred
of lines.

Why splice infrastructure doesnt fit your needs ?



