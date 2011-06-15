Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab1FOJnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 05:43:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55641 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab1FOJnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 05:43:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=F6PstvGBcKGJM1cRaZ5uY1V81sCy54fkQR0j/p05ixC/a1P9AkHgrXqyUyChkmQPcg
         JfDMnV2jBQyMpH4thQawcS/ccHIBhm5xKRP9TH1JqbkYB0i5jxVyfgdqCFvQmAxwwEIi
         ZGW9vJfEk/Lc0in2Ya5+nMgwVc/9LClS4ufmQ=
Subject: Re: tc match MAC destination
From: Eric Dumazet <eric.dumazet@gmail.com>
To: ierdnah@gmail.com
Cc: linux-kernel@vger.kernel.org, pdoru.kernel@evox.ro, netdev@vger.kernel.org
In-Reply-To: <1308125523.30324.64.camel@ierdnac-hp>
References: <1308125523.30324.64.camel@ierdnac-hp>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Jun 2011 11:43:28 +0200
Message-ID: <1308131008.9302.6.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 15 juin 2011 à 11:12 +0300, Andrei Popa a écrit :
> Hello,
> 
> I want to shape PVSTP+ traffic (traffic that has MAC destination
> 01:00:0c:cc:cc:cd) and it doesn't work.
> I've tried
> filter parent 1: protocol 802_3 pref 2 u32 fh 802::11 order 17 key ht
> 802 bkt 0 flowid 1:3 
>   match 01000ccc/ffffffff at 0
> but it doesn't work.
> 
> With
> filter parent 1: protocol arp pref 1 u32 
> filter parent 1: protocol arp pref 1 u32 fh 801: ht divisor 1 
> filter parent 1: protocol arp pref 1 u32 fh 801::7 order 7 key ht 801
> bkt 0 flowid 1:3 
>   match 00000000/00000000 at 0
> filter parent 1: protocol 802_3 pref 2 u32 
> filter parent 1: protocol 802_3 pref 2 u32 fh 802: ht divisor 1 
> filter parent 1: protocol 802_3 pref 2 u32 fh 802::3 order 3 key ht 802
> bkt 0 flowid 1:3 
>   match 00000000/00000000 at 0
>         action order 1: mirred (Egress Mirror to device ifb1) pipe
>         index 1923 ref 1 bind 1
> 
> I see arp trafic with tcpdump on ifb1, but no STP traffic or any kind of
> traffic except arp, because I've matched all MAC addreses.
> Can somebody verify that this match works ?
> 
> I use kernel 2.6.39.1.
> 
> Thank you,

Hi Andrei

Since you refer to a very complex network setup, it would really help if
you provide a self contained script so that we can take a look.

We netdev guys saw your first mail days ago but are a bit busy, so the
7th point listed in "REPORTING-BUGS" would be nice :

[7.] A small shell script or example program which triggers the problem


