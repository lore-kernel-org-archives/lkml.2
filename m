Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1CNNOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 09:14:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36686 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1CNNO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 09:14:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=erKRUZGBcGgtYJkjTbACz0pxyUyX8kdaM2VVErPV8BGwD7sXchaSG9X7d7U3LJ2lcK
         vySKtQbxAuG12pmwh9QRSQDw6DDUnbObZ7yGW9ucwRKph1gN/dzDNgi6Sj0nywJRVhPt
         ALA280ySWSxaNioX0Miv6omeuaryzEP+4BTGo=
Subject: Re: kernel 2.6.37 : oops in cleanup_once
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <4D7DF1A3.6020501@univ-nantes.fr>
References: <4D491B8D.1000107@univ-nantes.fr>
	 <1296643972.20445.9.camel@edumazet-laptop>
	 <1296645887.20445.11.camel@edumazet-laptop>
	 <4D495765.4090806@univ-nantes.fr>
	 <1296658407.20445.19.camel@edumazet-laptop>
	 <4D49726C.6020103@univ-nantes.fr>
	 <1296659336.20445.22.camel@edumazet-laptop>
	 <4D7DF1A3.6020501@univ-nantes.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Mar 2011 14:14:24 +0100
Message-ID: <1300108464.3423.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 14 mars 2011 à 11:44 +0100, Yann Dupont a écrit :
> Le 02/02/2011 16:08, Eric Dumazet a écrit :
> 
> 
> > I suspect a mem corruption from another layer (not inetpeer)
> >
> > Unfortunately many kmem caches share the "64 bytes" cache.
> >
> > Could you please add "slub_nomerge" on your boot command ?
> >
> ...
> 
> >
> >> -Is there a very severe impact on performance ?
> >>
> > not at all
> >
> Maybe there is an impact after all : since then, we don't have problems 
> anymore !
> 
> linkwood:~# uptime
>   11:42:03 up 39 days, 17:08,  3 users,  load average: 0.01, 0.03, 0.05
> 
> So... could slub_nomerge hide or simply avoid the problem ?
> Or are we just lucky this time ?
> 
> 

I would say you are lucky ;)

Not all memory corruptions are noticed. Sometimes it touch unused parts
of memory, or some parts with no critical content.



