Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965480Ab0COQ6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:58:40 -0400
Received: from mail.perches.com ([173.55.12.10]:1701 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965417Ab0COQ6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:58:36 -0400
Subject: Re: [PATCH] net/netfilter/ipvs/ip_vs_ftp.c: Remove use of NIPQUAD
From: Joe Perches <joe@perches.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Wensong Zhang <wensong@linux-vs.org>, Simon Horman <horms@verge.net.au>,
       Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org, lvs-devel <lvs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B9E5E43.9060206@trash.net>
References: <1268094699.1617.5.camel@Joe-Laptop.home>
	 <4B9E5E43.9060206@trash.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Mar 2010 09:58:34 -0700
Message-ID: <1268672314.4027.46.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 17:20 +0100, Patrick McHardy wrote:
> Joe Perches wrote:
> > NIPQUAD has very few uses left.
> > Remove this use and make the code have the identical form of the only
> > other use of "%u,%u,%u,%u,%u,%u" in net/ipv4/netfilter/nf_nat_ftp.c
> 
> Are we trying to remove NIPQUAD? 

That is a goal for me yes.
Elimination of unnecessary stuff from kernel.h is useful.

> In my opinion the current code is
> preferrable to open-coding NIPQUAD.

$ grep -r --include=*.[ch] NIPQUAD *
include/linux/kernel.h:#define NIPQUAD(addr) \
include/linux/kernel.h:#define NIPQUAD_FMT "%u.%u.%u.%u"
net/netfilter/ipvs/ip_vs_ftp.c:		sprintf(buf, "%u,%u,%u,%u,%u,%u", NIPQUAD(from.ip),

As of right now NIPQUAD_FMT is unused and
could be removed from kernel.h

There's 1 use of NIPQUAD.

Maybe instead of removal the #define could be
moved to netfilter.h or netfilter_ipv4.h

Another is to consolidate the two uses of
"%u,%u,%u,%u,%u,%u"

$ grep -r --include=*.[ch] "%u,%u,%u,%u,%u,u%" *
fs/cachefiles/bind.c:	_enter("{%u,%u,%u,%u,%u,%u},%s",
net/ipv4/netfilter/nf_nat_ftp.c:		return snprintf(buffer, buflen, "%u,%u,%u,%u,%u,%u",
net/netfilter/ipvs/ip_vs_ftp.c:		sprintf(buf, "%u,%u,%u,%u,%u,%u", NIPQUAD(from.ip),

Maybe these 2 open coded sprintf/snprintf could be
consolidated and moved to an appropriate include
like netfilter_ipv4 or another.

What do you suggest?

