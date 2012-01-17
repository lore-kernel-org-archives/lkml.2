Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2AQSwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:52:34 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56738 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab2AQSwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:52:33 -0500
Date: Tue, 17 Jan 2012 13:52:27 -0500 (EST)
Message-Id: <20120117.135227.1766844710849171296.davem@davemloft.net>
To: joe@perches.com
Cc: mirq-linux@rere.qmqm.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsprintf: Prevent NULL dereference using %pNF
From: David Miller <davem@davemloft.net>
In-Reply-To: <1326826273.17202.11.camel@joe2Laptop>
References: <1326825433.17202.6.camel@joe2Laptop>
	<20120117.134640.1673981737109339596.davem@davemloft.net>
	<1326826273.17202.11.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Jan 2012 10:52:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 17 Jan 2012 10:51:13 -0800

> On Tue, 2012-01-17 at 13:46 -0500, David Miller wrote:
>> From: Joe Perches <joe@perches.com>
>> Date: Tue, 17 Jan 2012 10:37:13 -0800
>> > Passing NULL to %pNF is done in skb_gso_segment
>> > which could be dereferenced.
>> skb_gso_segment() should be fixed instead.
> 
> Maybe.  Dereferencing NULL is bad form.

We don't check for NULL for IPV4 or IPV6 addresses, no reason
to treat this any differently.

Either do it for all %pX things, or none of them.
