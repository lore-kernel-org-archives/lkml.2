Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab0I3Swx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 14:52:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35157 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab0I3Sww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 14:52:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kCbFFX2YSp3LLePG/elVAL5StIlnP2vd/6nGbFJgXRoaY21Cgegs4ddK2/kjojTgIp
         nHRnnpzKkPwEVGyb27OKw4dc3ec+W/tBGrXQzDXfhBEYds++3C5wC9wKCWICDNbXVxl/
         YUY7/HEPTWQnU1EopB/K+ha9HG88WODkItM6s=
Subject: Re: Packet time delays on multi-core systems
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Vlasov <renton@renton.name>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20100930181556.GC4094@beaver.vrungel.ru>
References: <20100929191851.GC86786@beaver.vrungel.ru>
	 <1285796721.5211.156.camel@edumazet-laptop>
	 <20100930062419.GD86786@beaver.vrungel.ru>
	 <1285828432.5211.812.camel@edumazet-laptop>
	 <20100930122321.GA1575@beaver.vrungel.ru>
	 <1285850669.2615.426.camel@edumazet-laptop>
	 <20100930173732.GB4094@beaver.vrungel.ru>
	 <1285869782.2615.920.camel@edumazet-laptop>
	 <20100930181556.GC4094@beaver.vrungel.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 20:52:45 +0200
Message-ID: <1285872765.2615.1008.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 30 septembre 2010 à 22:15 +0400, Alexey Vlasov a écrit :
> On Thu, Sep 30, 2010 at 08:03:02PM +0200, Eric Dumazet wrote:
> > >  
> > > The last test were made already concerning such rx queue binding:
> > > # cat /proc/irq/60/smp_affinity
> > > 001000
> > > # cat /proc/irq/61/smp_affinity
> > > 010000
> > > # cat /proc/irq/62/smp_affinity
> > > 080000
> > > # cat /proc/irq/63/smp_affinity
> > > 800000
> > > 
> > 
> > Why 60, 61, 62, 63 ? This should be 753, 754, 755, 756
> 
> I've got several similar servers, the interrups 60-63 are on
> that one that I can test now, so this isn't a mistake.
> 

If you have a burst of 'LOG' matches, it can really slow down the whole
thing.

You should add a limiter (eg: no more than 5 messages per second)

http://netfilter.org/documentation/HOWTO/packet-filtering-HOWTO-7.html

	This module is most useful after a limit match, so you don't
	flood your logs.



