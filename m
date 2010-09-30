Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab0I3MrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:47:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45280 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab0I3Mq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TScoMN0FbzBwn5ATns5OzscOSFJy3tA6hquT3D6LfK+0S/w607CN5aGSeLU/VblyBD
         wgFkBShIUumc/UT4XkYKTVMeT98GHeyfrBYkieM/Z0zAFy9UDRU8ZzFzMo9vQqeePuaU
         mCkTc0m7yHjGzT/XGfPdNtUtibTrrE8FJO3gs=
Subject: Re: Packet time delays on multi-core systems
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Vlasov <renton@renton.name>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20100930123048.GA4094@beaver.vrungel.ru>
References: <20100929191851.GC86786@beaver.vrungel.ru>
	 <1285796721.5211.156.camel@edumazet-laptop>
	 <20100930123048.GA4094@beaver.vrungel.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 14:46:52 +0200
Message-ID: <1285850812.2615.432.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 30 septembre 2010 à 16:30 +0400, Alexey Vlasov a écrit :
> On Wed, Sep 29, 2010 at 11:45:21PM +0200, Eric Dumazet wrote:
> > But if you send SYN packets in the same time, (logged), this might
> > slow
> > down the reception (and answers) of ICMP frames. LOG target can be
> > quite
> > expensive...
> 
> Yes, it's clear that  some slow down can appear, but 100 ms is too much,
> and this happens at 200 SYN packets in 2 minutes just as in my example.
> On old servers where some tx/rx are missing in NIC card I don't see
> such a situation even at more then 1000 SYN-packets per sec.

Because all cpus were servicing interrupts, which was good for your
needs. Things apparently changed with 2.6.32. 

You have a multiqueue NIC, but using a single CPU to handle the
workload.

> 
> > Is using other rules gives same problem ?
> >
> > iptables -A OUTPUT -p tcp -m tcp --dport 80 --tcp-flags
> 
> No, only LOG gives such a scheme.
> 


