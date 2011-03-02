Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab1CBTsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:48:54 -0500
Received: from 110-197-170-69.skybeam.com ([69.170.197.110]:41732 "EHLO
	chukar.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756516Ab1CBTsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:48:52 -0500
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Mar 2011 14:48:52 EST
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
Subject: Re: [PATCH v2] net: don't allow CAP_NET_ADMIN to load non-netdev kernel modules
References: <201102272122.52643.arnd@arndb.de>
	<4D6B6AE7.2050202@msgid.tls.msk.ru> <20110228095133.GA4351@albatros>
	<20110228.112349.104067277.davem@davemloft.net>
	<20110301194845.GA3533@albatros>
	<1299010390.2529.30.camel@bwh-desktop>
	<20110301213313.GA6507@albatros>
Date: Wed, 02 Mar 2011 12:39:53 -0700
In-Reply-To: <20110301213313.GA6507@albatros> (Vasiliy Kulikov's message of
	"Wed, 2 Mar 2011 00:33:13 +0300")
Message-ID: <m34o7ltipi.fsf@lwn.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am probably missing something, but shouldn't the existing
MODULE_ALIASes stay?

Vasiliy Kulikov <segoon@openwall.com> writes:

> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index 6613edf..d1d0e2c 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -1765,4 +1765,4 @@ module_exit(ipgre_fini);
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_RTNL_LINK("gre");
>  MODULE_ALIAS_RTNL_LINK("gretap");
> -MODULE_ALIAS("gre0");
> +MODULE_ALIAS_NETDEV("gre0");

that is, instead of replacing MODULE_ALIAS("gre0") with the NETDEV
version, don't you want both for backward compatibility?

(if so, same goes for the other two)

jake

-- 
Jake Edge - jake@lwn.net - http://lwn.net
