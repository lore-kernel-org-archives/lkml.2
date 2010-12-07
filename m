Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab0LGVDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:03:01 -0500
Received: from mail.solarflare.com ([216.237.3.220]:38839 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab0LGVDA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:03:00 -0500
Subject: Re: bugs/regressions: report in LKML or in bugzilla?
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <1291738321.2695.338.camel@edumazet-laptop>
References: <201012071639.58884.Martin@lichtvoll.de>
	 <1291738321.2695.338.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Tue, 07 Dec 2010 21:02:56 +0000
Message-ID: <1291755776.21627.13.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 Dec 2010 21:02:59.0290 (UTC) FILETIME=[20DB03A0:01CB9652]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17814.005
X-TM-AS-Result: No--27.356100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 17:12 +0100, Eric Dumazet wrote:
> Le mardi 07 décembre 2010 à 16:39 +0100, Martin Steigerwald a écrit :
> 
> > A participant of a linux performance training I hold found a bug with 
> > window scaling which did not receive any reply as well:
> > 
> > Bug 20312 -  System freeze with multiples of 32 in 
> > /proc/sys/net/ipv4/tcp_adv_win_scale
> > https://bugzilla.kernel.org/show_bug.cgi?id=20312
> > 
> 
> User bug ?
> 
> Documentation/networking/ip-sysctl.txt
> 
> tcp_adv_win_scale - INTEGER
> 	Count buffering overhead as bytes/2^tcp_adv_win_scale 
> 	(if tcp_adv_win_scale > 0) or bytes-bytes/2^(-tcp_adv_win_scale),
> 	if it is <= 0.
> 	Default: 2
> 
> Given we use 32bit numbers, using values outside of [-31 ... 31] makes litle sense.
> 
> We could add sysctl range limit, but user should not mess with 
> /proc/sys/net/ipv4/parameters unless he knows what he is doing ?
[...]

For mere humans, the range is not quite os obvious.  Which is why this
has been fixed in net-2.6 (as noted on that bug report now).

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

