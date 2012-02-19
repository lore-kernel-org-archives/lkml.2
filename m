Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab2BTAAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:00:22 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40647 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab2BTAAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:00:20 -0500
Date: Sun, 19 Feb 2012 18:59:56 -0500 (EST)
Message-Id: <20120219.185956.2140542911171040902.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: thomas@m3y3r.de, linux-kernel@vger.kernel.org, jcliburn@gmail.com,
        chris.snook@gmail.com, netdev@vger.kernel.org, jwboyer@gmail.com
Subject: Re: [PATCH] atl1c: dont use highprio tx queue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329374591.5646.23.camel@edumazet-laptop>
References: <1329373082.5646.9.camel@edumazet-laptop>
	<21390AB8-BD9B-44D7-B2CE-B20AF7605CE7@m3y3r.de>
	<1329374591.5646.23.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 19 Feb 2012 15:59:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 16 Feb 2012 07:43:11 +0100

> This driver attempts to use two TX rings but lacks proper support :
> 
> 1) IRQ handler only takes care of TX completion on first TX ring
> 2) the stop/start logic uses the legacy functions (for non multiqueue
> drivers)
> 
> This means all packets witk skb mark set to 1 are sent through high
> queue but are never cleaned and queue eventualy fills and block the
> device, triggering the infamous "NETDEV WATCHDOG" message. 
> 
> Lets use a single TX ring to fix the problem, this driver is not a real
> multiqueue one yet.
> 
> Minimal fix for stable kernels.
> 
> Reported-by: Thomas Meyer <thomas@m3y3r.de>
> Tested-by: Thomas Meyer <thomas@m3y3r.de>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied.
