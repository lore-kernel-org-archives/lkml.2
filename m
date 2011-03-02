Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1CBUik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:38:40 -0500
Received: from tex.lwn.net ([70.33.254.29]:49052 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab1CBUij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:38:39 -0500
Date: Wed, 2 Mar 2011 13:38:35 -0700
From: Jake Edge <jake@lwn.net>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, mjt@tls.msk.ru, arnd@arndb.de,
        mirqus@gmail.com, netdev@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, eric.dumazet@gmail.com, therbert@google.com,
        xiaosuo@gmail.com, jesse@nicira.com, kees.cook@canonical.com,
        eugene@redhat.com, dan.j.rosenberg@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] net: don't allow CAP_NET_ADMIN to load non-netdev
 kernel modules
Message-ID: <20110302133835.5e267e9e@chukar>
In-Reply-To: <20110302201807.GA31965@albatros>
References: <201102272122.52643.arnd@arndb.de>
	<4D6B6AE7.2050202@msgid.tls.msk.ru>
	<20110228095133.GA4351@albatros>
	<20110228.112349.104067277.davem@davemloft.net>
	<20110301194845.GA3533@albatros>
	<1299010390.2529.30.camel@bwh-desktop>
	<20110301213313.GA6507@albatros>
	<m34o7ltipi.fsf@lwn.net>
	<20110302194354.GA31043@albatros>
	<20110302124936.289a1915@chukar>
	<20110302201807.GA31965@albatros>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011 23:18:07 +0300 Vasiliy Kulikov wrote:

> > and on systems that today use CAP_SYS_MODULE
> 
> Since Linux 2.6.32 CAP_SYS_MODULE may not load modules via "ifconfig
> gre0".  It was changed to CAP_NET_ADMIN.  So nothing is broken here.
> 
> > (or really the full set of
> > capabilities cuz they are running as root)?
> 
> As root has CAP_NET_ADMIN, the alias netdev-gre0 is tried and it
> succeeds.

(I feel like I'm beating a dead horse here, sorry if so ...)

If I have a setuid-root program today that loads ip_gre by using the
alias "gre0", and I run that program on a kernel with this change,
won't it fail because the "gre0" alias is missing?  That program
doesn't know to try "netdev-gre0". i.e. won't backward compatibility be
affected by this change?

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
