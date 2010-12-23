Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab0LWJDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 04:03:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:48454 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab0LWJDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 04:03:20 -0500
Date: Thu, 23 Dec 2010 10:03:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
        =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Subject: Re: [PATCH] tcp: cleanup of cwnd initialization in
 tcp_init_metrics()
In-Reply-To: <1293092671.2679.44.camel@edumazet-laptop>
Message-ID: <alpine.LNX.2.00.1012231002310.16569@pobox.suse.cz>
References: <alpine.LNX.2.00.1012221938030.16569@pobox.suse.cz> <1293092671.2679.44.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Dec 2010, Eric Dumazet wrote:

> Le mercredi 22 décembre 2010 à 19:39 +0100, Jiri Kosina a écrit :
> > Commit 86bcebafc5e7f5 ("tcp: fix >2 iw selection") fixed a case when 
> > congestion window initialization has been mistakenly omitted by 
> > introducing cwnd label and putting backwards jump from the end of the 
> > function.
> > 
> > This makes the code unnecessarily tricky to read and understand on a first 
> > sight.
> > 
> > Shuffle the code around a little bit to make it more obvious.
> 
> Well in fine you have
> 
> 	if (inet_csk(sk)->icsk_rto < TCP_TIMEOUT_INIT && !tp->rx_opt.saw_tstamp)
> 		goto reset;
> 	goto out;
> reset:
> 
> Is that really more obvious ? ;)

To me it seems much more obvious than goto from the very end of the 
function somewhere into the middle and returning from there, but 
definitely a matter of personal taste.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
