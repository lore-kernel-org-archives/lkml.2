Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab1L3WMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 17:12:16 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:44498 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab1L3WMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 17:12:13 -0500
Date: Fri, 30 Dec 2011 17:09:05 -0500 (EST)
Message-Id: <20111230.170905.1348056803377924696.davem@davemloft.net>
To: joshhunt00@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] IPv6: Avoid taking write lock for
 /proc/net/ipv6_route
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAKA=qzbZ4x5u1bBM0gAECeMNutyaVzp1FmRPwKHsBEEs7984ag@mail.gmail.com>
References: <CAKA=qzbZ4x5u1bBM0gAECeMNutyaVzp1FmRPwKHsBEEs7984ag@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 30 Dec 2011 14:09:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Hunt <joshhunt00@gmail.com>
Date: Wed, 28 Dec 2011 17:23:07 -0600

> lock_stat shows taking the write lock is causing the slowdown. Using
> this info I decided to write a version of fib6_clean_all() which
> replaces write_lock_bh(&table->tb6_lock) with
> read_lock_bh(&table->tb6_lock). With this new function I see the same
> results as with my rtnetlink iperf test. I guess my question is what
> am I missing? Is there a reason you need to take the write lock when
> reading the route table to display to proc?

You're not missing anything, it's just an oversight or laziness. :-)

I've applied your patch thanks.

Longer term we should make the ipv6 tree traversals RCU safe just
like net/ipv4/fib_trie.c is.  Then we can do away with even the
read locks for read-only traversals.

