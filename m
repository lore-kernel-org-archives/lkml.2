Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab0I2FYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:24:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52267
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977Ab0I2FYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:24:53 -0400
Date: Tue, 28 Sep 2010 22:25:10 -0700 (PDT)
Message-Id: <20100928.222510.71109554.davem@davemloft.net>
To: gwurster@scs.carleton.ca
Cc: kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, shemminger@vyatta.com,
        eric.dumazet@gmail.com, herbert@gondor.hengli.com.au,
        ebiederm@xmission.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-2.6 v2] IPv6: Create temporary address if none
 exists.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100927170430.GA7106@adams.ccsl.carleton.ca>
References: <20100927170430.GA7106@adams.ccsl.carleton.ca>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glenn Wurster <gwurster@scs.carleton.ca>
Date: Mon, 27 Sep 2010 13:04:30 -0400

> If privacy extentions are enabled, but no current temporary address exists,
> then create one when we get a router advertisement.
> 
> Version 2, now with 100% fewer line wraps.  Thanks to David Miller for
> pointing out the line wrapping issue.
> 
> Signed-off-by: Glenn Wurster <gwurster@scs.carleton.ca>

The existing code is correct from what I can tell.

Variable "create" is true when "ifp == NULL" and "valid_lft != 0"

And RFC 3041 explicitly states in section 3.3:

	When a new public address is created as described in [ADDRCONF]
	(because the prefix advertised does not match the prefix of any
	address already assigned to the interface, and Valid Lifetime
	in the option is not zero), also create a new temporary address.

Your patch is going to cause us to create a temporary address even
when valid_lft is zero, which the RFC says we should not do.

That goes against what the RFC tells us to do, so I can only conclude
that your patch is not correct.

I'm not applying this, sorry.

