Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab1AUWN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 17:13:28 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63610 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab1AUWNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 17:13:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IG7CeEnkwgsowjEclSS8XwZIY5I/ZAGvT5NNCLeRJkAl5E2Y76ko4QvgQ5yj1I9tgB
         cCmjsHhV3RkI/fJj6Yh8ECjJqu8c809umKiygc0sjC5gPZ0PiFck0zRc7OyLyVvt/oLR
         pdOrdgMlByOMvH3R0XBlLlK0rsmx/Jw2tH0mA=
Subject: Re: 2.6.38-rc1: arp triggers RTNL assertion
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: jamie@audible.transient.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20110121.130657.106806953.davem@davemloft.net>
References: <20110121061758.GA2247@fifty-fifty.audible.transient.net>
	 <1295593946.2613.52.camel@edumazet-laptop>
	 <1295635976.2609.23.camel@edumazet-laptop>
	 <20110121.130657.106806953.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 23:13:19 +0100
Message-ID: <1295647999.2609.31.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 21 janvier 2011 à 13:06 -0800, David Miller a écrit :
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Fri, 21 Jan 2011 19:52:56 +0100
> 
> > Here is how I fixed this, thanks again Jamie !
> > 
> > [PATCH] net: neighbour: pneigh_lookup() doesnt need RTNL
> 
> Eric, I don't think we can do this.
> 
> Fundamentally, any time a user operation changes the configuration
> of the networking, we must hold the RTNL.
> 
> Eliding the RTNL for lookups is fine, but for things that change
> state it is not.
> 
> I therefore think you'll need to rework the arp_ioctl() portions
> of the commit that introduced this regression.
> 

Hmm, I'll think about it, no problem.


