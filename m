Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab0KVTOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 14:14:09 -0500
Received: from yop.chewa.net ([91.121.105.214]:40024 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab0KVTOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 14:14:07 -0500
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Nov 2010 14:14:07 EST
From: "=?iso-8859-15?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
Organization: Remlab.net
To: Alban Crequy <alban.crequy@collabora.co.uk>, netdev@vger.kernel.org
Subject: Re: [PATCH 7/9] AF_UNIX: Documentation on multicast Unix Sockets
Date: Mon, 22 Nov 2010 21:07:40 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.8; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20101122183447.124afce5@chocolatine.cbg.collabora.co.uk> <1290450982-17480-7-git-send-email-alban.crequy@collabora.co.uk>
In-Reply-To: <1290450982-17480-7-git-send-email-alban.crequy@collabora.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011222107.41548.remi@remlab.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 22 novembre 2010 20:36:20 Alban Crequy, vous avez écrit :
> +Multicast Unix sockets
> +======================
> +
> +Multicast group memberships are stored in struct unix_mcast nodes. An Unix
> +socket can join several multicast groups. Struct unix_mcast nodes are
> doubly +linked:
> +- In (struct unix_sock)->mcast_subscriptions
> +- In (struct unix_sock)->mcast_members

I may be stupid, but I found this whole documentation very confusing, and so 
the API it tries to describe. Traditionally:
- Senders may or not may be part of the group and are not kept track of.
- Receivers join to the group then receive message sent to it.
- Loopback defines whether a sender receives its own echo if it sends to a
group that it has joined.
- If connected to a multicast group, messages from the socket are routed to 
the group (in absence of a contradictoy socket address). This has no effect on 
membership to the multicast group under any circumstance.

You cannot 'listen' or 'accept' on a multicast group.

So I am not entirely clear what semantics your patchset is following. But it 
does not seem like "multicast" to me and therefore seems not very well 
documented :-(

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
