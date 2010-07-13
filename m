Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab0GMPt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 11:49:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50339 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab0GMPt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 11:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=f3ne3lgUbUF2K2sgMOzplliPOl1Q1bfXxHp7VvemUqU3Z0LkcLV59r3U7ccGhBSv2p
         lsoETX+jobSSIbuzJbhajncgR8ME4ogavjINUVWa/9tTMuXm1y2GUIO3THnBFk5AU8eC
         3vkQhNlxlPnyNB6CUn6XBbfRzNcJUl/uSYonY=
Subject: Re: [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Felipe W Damasio <felipewd@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, David Miller <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTilrIByt4xAHhsBsKo3nDfv0_c3sF-dCiTiYiPnu@mail.gmail.com>
References: <AANLkTimn8A0cYZmwNZYitRkBHKKFe4HQ5GU626DLugkk@mail.gmail.com>
	 <AANLkTil49m6Ul2bauiH4Pwn-6ykrYTFmSO6_SxqQgD_e@mail.gmail.com>
	 <1278626921.2435.73.camel@edumazet-laptop>
	 <AANLkTiliBClahTfb41M5BDi1etg5pgkqEz_VfGrn_mK4@mail.gmail.com>
	 <1278695580.2696.55.camel@edumazet-laptop>
	 <AANLkTil39xHOhcdAo4h_jWtx_UuYdFHGdQVAdwPMd7QJ@mail.gmail.com>
	 <1278742649.2538.17.camel@edumazet-laptop> <4C395459.6080407@redhat.com>
	 <1278835332.2538.51.camel@edumazet-laptop>
	 <AANLkTikEGuFtTlIKUfti6GDsdBz99PpKRCs5lEeEM86u@mail.gmail.com>
	 <AANLkTilbEkJWPqvJE72r9HdFQSU84S02BKZB0CH-8QwB@mail.gmail.com>
	 <AANLkTimn9x17g-4K7fS4MjmCgzHuBARurEoFVd_gId7m@mail.gmail.com>
	 <1279032023.2634.384.camel@edumazet-laptop>
	 <AANLkTilrIByt4xAHhsBsKo3nDfv0_c3sF-dCiTiYiPnu@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 17:49:53 +0200
Message-ID: <1279036193.2634.468.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 13 juillet 2010 à 11:49 -0300, Felipe W Damasio a écrit :
> Hi Mr. Dumazet,
> 
> 2010/7/13 Eric Dumazet <eric.dumazet@gmail.com>:
> > I currently have no fresh ideas. If you want this problem to be solved,
> > its important to setup in your lab a workload to trigger again and again
> > the bug, in order to provide us more crash information.
> 
>  Right. I've been running non-stop since the first bug happened, but
> so far the problem hasn't surfaced again :-(
> 
>  I've been using the kernel with the patch that you provided me
> (nf_tproxy.c). Is there a chance that patch fixed the problem?

This is a real bug, but I dont think it can fix your problem.

Looking again at your crash, we see RCX=0x720, decimal 1824

As its skb->len, we are freeing an skb that was collapsed or something
like that, since 1824 > 1460 (the normal MSS on ethernet)

GRO is off on your machine.

But coincidently 0x0720 is also a blank char for VGA screen...
(0x20 : ASCII space, 0x07 : default attribute)

So maybe you hit a corruption outside of network stack.



