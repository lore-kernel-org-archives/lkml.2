Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab2BVBcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:32:06 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:34474 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab2BVBcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:32:04 -0500
Date: Tue, 21 Feb 2012 20:29:51 -0500 (EST)
Message-Id: <20120221.202951.1813857124104871565.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: padovan@profusion.mobi, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, hjl.tools@gmail.com, marcel@holtmann.org,
        hpa@zytor.com
Subject: Re: linux-next: build failure after merge of the bluetooth tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120222122109.7aef5c672df3bab843214606@canb.auug.org.au>
References: <20120222122109.7aef5c672df3bab843214606@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 21 Feb 2012 17:29:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 22 Feb 2012 12:21:09 +1100

> Hi Gustavo,
> 
> After merging the bluetooth tree, today's linux-next build
> (x86_64_allmodconfig) failed like this:
> 
> net/bluetooth/hci_sock.c: In function 'hci_sock_cmsg':
> net/bluetooth/hci_sock.c:738:8: error: 'COMPAT_USE_64BIT_TIME' undeclared (first use in this function)
> 
> Caused by commit aebb77ca6ad1 ("compat: Use COMPAT_USE_64BIT_TIME in the
> Bluetooth subsystem").  That symbol doesn't exist anywhere in linux-next ...
> 
> I have used the bluetooth from next-20120221 for today.
> 
> P.S. that commit is supposedly authored by H. J. Lu but does not contain
> a Signed-off-by from him.

That patch series was meant to go in as a group, because all of the
subsequent patches depend upon patches earlier in the series.

There is zero reason you should have applied that patch into your
bluetooth subsystem tree.  The fact that it wasn't adequately build
tested either I find quite troubling.

Lots of red cards for the bluetooth maintainers today.
