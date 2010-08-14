Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab0HNQOD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 12:14:03 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57247 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab0HNQOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 12:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oS338v3byHP4xV5Sq926JNqLIC5+vaUTWKezGuVP/6E6DS92upJguGxlldfZf+u2PA
         MOJ8222XWYBJhX4enShwwY5T7k+syXQ8Ry3SeGaMYyKKqRU7frimJ7ZjvvC9vTMaP3p3
         /TvuIEht+d+YyxNI/IKrcExRuvdSL24dw2u/o=
Date: Sat, 14 Aug 2010 20:13:29 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@web.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, Andrew Lunn <andrew@lunn.ch>,
        Sven Eckelmann <sven.eckelmann@gmx.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: batman-adv: design suggestions
Message-ID: <20100814161329.GA3258@albatros>
References: <20100809203403.GA16183@albatros>
 <20100813181833.GA5632@albatros>
 <201008141659.14868.lindner_marek@yahoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008141659.14868.lindner_marek@yahoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 16:59 +0200, Marek Lindner wrote:
> On Friday 13 August 2010 20:18:33 Vasiliy Kulikov wrote:
> > d) Why do you send icmp TTL exceeded for the icmp itself? E.g. in case
> > of loop or/and small default TTL you'll probably get a storm of icmps.
> > Exactly in this case IP silently drops TTL exceeded icmps ;)
> 
> These layer2 icmp packets are not ordinary icmp packets.

By the way, it's better to name it smth another (bcmp?) as ICMP = _internet_
control message protocol. Batman is not limited to IP however ;)

> We needed to provide 
> a mechanism to make the network topology visible to debug tools like ping or 
> traceroute which normally "see" no more than one hop as they operate on 
> layer3. Hence, batman-adv does not send an icmp packet for each payload TTL 
> exceeded but for traceroute only.

Ah, dammit! I didn't see this code:

	if (icmp_packet->msg_type != ECHO_REQUEST) {
		pr_warning("Warning - can't forward icmp packet from %pM to "
			   "%pM: ttl exceeded\n", icmp_packet->orig,
			   icmp_packet->dst);
		return NET_RX_DROP;
	}

I thought that any expired icmp spawns TTL exceeded icmp that may spawn
another one, etc.

> I recommend reviewing the traceroute code to 
> understand how this is supposed to work:
> http://www.open-mesh.org/browser/trunk/batctl/traceroute.c

Thanks, I'll look at it.

> 
> I'd be interested to learn about a problematic scenario in which this 
> mechanism breaks.

Now I don't know anyone too ;)

> 
> Regards,
> Marek
