Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0KMWxd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 17:53:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:51984 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0KMWxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 17:53:31 -0500
Subject: Re: Kernel rwlock design, Multicore and IGMP
From: Peter Zijlstra <peterz@infradead.org>
To: Cypher Wu <cypher.w@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	 <1289489007.17691.1310.camel@edumazet-laptop>
	 <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Nov 2010 23:53:46 +0100
Message-ID: <1289688826.2109.400.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 11:32 +0800, Cypher Wu wrote:
> It seems not a problem that read_lock() can be nested or not since
> rwlock doesn't have 'owner', 

You're mistaken.

> it's just that should we give
> write_lock() a priority than read_lock() since if there have a lot
> read_lock()s then they'll starve write_lock().

We rely on that behaviour. FWIW write preference locks will starve
readers.

> We should work out a well defined behavior so all the
> platform-dependent raw_rwlock has to design under that principle. 

We have that, all archs have read preference rwlock_t, they have to,
code relies on it.
