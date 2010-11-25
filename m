Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0KYOFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:05:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46528 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab0KYOFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:05:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OBfevLgzPvJt7FLv5NmOfdUxWr0V7hajcPqwNp2djfkBS9nxDRYJIsQlf3BvC6QIfo
         3Z1gEmHMhUnxRFQNkmOXFchCs7D3ZOfbb2YRyGDWJuyzO/GQ4H040dJTJEhf7gp8EZcY
         ckV2y3bNLbe1xa7JKriJN9njDPUPdvnbb0iqQ=
Subject: Re: [PATCH 2/2] The new jhash implementation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <AANLkTi=jqRY18Omv2Y2a1XjT-SH8W--wJ7A4y4PV1oT1@mail.gmail.com>
References: <1290690908-794-1-git-send-email-kadlec@blackhole.kfki.hu>
	 <1290690908-794-2-git-send-email-kadlec@blackhole.kfki.hu>
	 <1290690908-794-3-git-send-email-kadlec@blackhole.kfki.hu>
	 <1290692943.2858.303.camel@edumazet-laptop>
	 <AANLkTi=jqRY18Omv2Y2a1XjT-SH8W--wJ7A4y4PV1oT1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 15:05:46 +0100
Message-ID: <1290693946.2858.323.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 25 novembre 2010 à 21:55 +0800, Changli Gao a écrit :

> > I suggest :
> >
> > #include <linux/unaligned/packed_struct.h>
> > ...
> >        a += __get_unaligned_cpu32(k);
> >        b += __get_unaligned_cpu32(k+4);
> >        c += __get_unaligned_cpu32(k+8);
> >
> > Fits nicely in registers.
> >
> 
> I think you mean get_unaligned_le32().
> 

No, I meant __get_unaligned_cpu32()

We do same thing in jhash2() :

	a += k[0]; 
	b += k[1];
	c += k[2];

We dont care of bit order of the 32bit quantity we are adding to a,b or
c , as long its consistent for the current machine ;)

get_unaligned_le32() would be slow on big endian arches.



