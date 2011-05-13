Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab1EMWWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 18:22:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46201 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab1EMWWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 18:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tFdZeS6S1KHK7djFGaAIuUAoSQaTL9IvE/GlEBOWlqDX0LjnbD8p2fYUkoMSDDLTE3
         hGK+fU9hbaaGzN6n/RhqzKARU2R2emnEuH5QSE/MT6CS60HVYr/jEQlQMiBBJINahCxj
         e8HyYFv2HIKmoKD/R+xMexLMNTzZGce0CknWo=
Subject: [PATCH net-next-2.6] net: ipv4: add ping_group_range documentation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, David Miller <davem@davemloft.net>,
        solar@openwall.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, peak@argo.troja.mff.cuni.cz,
        kees.cook@canonical.com, dan.j.rosenberg@gmail.com, eugene@redhat.com,
        nelhage@ksplice.com, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        linux-man@vger.kernel.org
In-Reply-To: <m2wrhuxp8c.fsf@firstfloor.org>
References: <20110510.121550.112583080.davem@davemloft.net>
	 <20110513200100.GA3875@albatros>  <m2wrhuxp8c.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 00:22:13 +0200
Message-ID: <1305325333.3120.36.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 13 mai 2011 à 14:30 -0700, Andi Kleen a écrit :
> Vasiliy Kulikov <segoon@openwall.com> writes:
> 
> > This patch adds IPPROTO_ICMP socket kind.  It makes it possible to send
> > ICMP_ECHO messages and receive the corresponding ICMP_ECHOREPLY messages
> > without any special privileges.  In other words, the patch makes it
> > possible to implement setuid-less and CAP_NET_RAW-less /bin/ping.  In
> > order not to increase the kernel's attack surface, the new functionality
> > is disabled by default, but is enabled at bootup by supporting Linux
> > distributions, optionally with restriction to a group or a group range
> > (see below).
> 
> You'll need to do a manpage patch too. Otherwise noone will know how to use
> it.

Yes probably...

It would be nice to copy part of changelog in 
Documentation/networking/ip-sysctl.txt


socket(2) is restricted to the group range specified in
"/proc/sys/net/ipv4/ping_group_range".  It is "1 0" by default, meaning
that nobody (not even root) may create ping sockets.  Setting it to "100
100" would grant permissions to the single group (to either make
/sbin/ping g+s and owned by this group or to grant permissions to the
"netadmins" group), "0 4294967295" would enable it for the world, "100
4294967295" would enable it for the users, but not daemons.


Too late here, time for sleep...


