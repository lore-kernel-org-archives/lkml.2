Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab1FQD65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 23:58:57 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41332 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab1FQD64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 23:58:56 -0400
Date: Thu, 16 Jun 2011 23:58:50 -0400 (EDT)
Message-Id: <20110616.235850.250279031614097414.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: shemminger@vyatta.com, gthelen@google.com, shemminger@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sky2: avoid using uninitialized variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1308282695.11457.48.camel@localhost>
References: <20110614000230.4166a1ae@s6510.ftrdhcpuser.net>
	<20110616.231018.84570655636629416.davem@davemloft.net>
	<1308282695.11457.48.camel@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 16 Jun 2011 20:58:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Fri, 17 Jun 2011 04:51:35 +0100

> On Thu, 2011-06-16 at 23:10 -0400, David Miller wrote:
>> From: Stephen Hemminger <shemminger@vyatta.com>
>> Date: Tue, 14 Jun 2011 00:02:30 -0400
>> 
>> > In my experience if phy reads once successfully, it is going
>> > to read every time. If there is a problem it only happens on
>> > the first access (powered off, bad timing, etc).
>> 
>> It also happens when the PHY can't get a response for a certain
>> register, for whatever reason, before internal hw timeouts trigger.
>> 
>> Please, check all MII accesses.  That's what I do in every driver
>> I've written.
> 
> It doesn't help that the mii_if_info operations are defined to never
> return errors.  This doesn't prevent drivers from doing so internally,
> but it does set a bad example.

I totally agree.
