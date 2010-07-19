Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966635Ab0GSTyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 15:54:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32875
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966583Ab0GSTyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 15:54:44 -0400
Date: Mon, 19 Jul 2010 12:55:00 -0700 (PDT)
Message-Id: <20100719.125500.257479409.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: ilpo.jarvinen@helsinki.fi, lennart.schulte@nets.rwth-aachen.de,
        tj@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        henning.fehrmann@aei.mpg.de, carsten.aulbert@aei.mpg.de
Subject: Re: [PATCHv2] tcp: fix crash in tcp_xmit_retransmit_queue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1279561148.2553.150.camel@edumazet-laptop>
References: <1279548555.2553.51.camel@edumazet-laptop>
	<alpine.DEB.2.00.1007192013010.30181@melkinpaasi.cs.helsinki.fi>
	<1279561148.2553.150.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 19 Jul 2010 19:39:08 +0200

> Do you know in what exact circumstance the bug triggers ?
> 
> It's hard to believe thousand of machines on the Internet never hit
> it :(
> 
> Maybe another problem in congestion control ?

This is something to investigate, but the conditions under which
tcp_fastretrans_alert() (the main invoker of tcp_xmit_retransmit_queue())
does it's thing are complicated enough that I'm going to add this fix
for the time being and push it out to stable too.

Thanks everyone.
