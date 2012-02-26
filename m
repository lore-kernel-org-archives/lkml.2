Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2BZTVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 14:21:25 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53523 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab2BZTVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 14:21:24 -0500
Date: Sun, 26 Feb 2012 14:20:38 -0500 (EST)
Message-Id: <20120226.142038.556939530554716833.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: paul.gortmaker@windriver.com, tim.bird@am.sony.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: RFC: memory leak in udp_table_init
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330147182.2462.25.camel@edumazet-laptop>
References: <4F48318E.8070902@am.sony.com>
	<CAP=VYLp7+Apubm=PHRLSw50V9zBKmV-xFRvcO4-qAogJVp7jcw@mail.gmail.com>
	<1330147182.2462.25.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 26 Feb 2012 11:20:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 25 Feb 2012 06:19:42 +0100

> [PATCH] mm: add a low limit to alloc_large_system_hash

I think you should just use zero as the default minimum for all
call sites except this UDP case we are trying to fix.

For example I see you used 16 for kernel/pid.c

Let's not try to do unrelated changes like that now, we can do such
tweaks later.
