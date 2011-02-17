Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1BQWw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 17:52:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51381
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703Ab1BQWw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 17:52:57 -0500
Date: Thu, 17 Feb 2011 14:53:33 -0800 (PST)
Message-Id: <20110217.145333.232751283.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: xiyou.wangcong@gmail.com, cypher.w@gmail.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, netdev@vger.kernel.org
Subject: Re: IGMP and rwlock: Dead ocurred again on TILEPro
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D5DA60A.8080201@tilera.com>
References: <20110217054237.GB2653@cr0.nay.redhat.com>
	<20110216.214625.189707123.davem@davemloft.net>
	<4D5DA60A.8080201@tilera.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 17 Feb 2011 17:49:46 -0500

> The fix is to disable interrupts for the arch_read_lock family of methods. 

How does that help handle the race when it happens between different
cpus, instead of between IRQ and non-IRQ context on the same CPU?

Why don't you just use the generic spinlock based rwlock code on Tile,
since that is all that your atomic instructions can handle
sufficiently?
