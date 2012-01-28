Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2A1CHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 21:07:17 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47653 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2A1CHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 21:07:16 -0500
Date: Fri, 27 Jan 2012 21:07:06 -0500 (EST)
Message-Id: <20120127.210706.1819458801435039273.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: eric.dumazet@gmail.com, xemul@parallels.com,
        sjur.brandeland@stericsson.com, levinsasha928@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com,
        sjurbren@gmail.com
Subject: Re: [PATCH 1/2] netns: Fail conspicously if someone uses
 net_generic at an inappropriate time.
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1ehumc8r4.fsf_-_@fess.ebiederm.org>
References: <m1zkdacbsx.fsf@fess.ebiederm.org>
	<20120126.180754.679593869814492219.davem@davemloft.net>
	<m1ehumc8r4.fsf_-_@fess.ebiederm.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 27 Jan 2012 18:07:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 26 Jan 2012 16:02:55 -0800

> By definition net_generic should never be called when it can return
> NULL.  Fail conspicously with a BUG_ON to make it clear when people mess
> up that a NULL return should never happen.
> 
> Recently there was a bug in the CAIF subsystem where it was registered
> with register_pernet_device instead of register_pernet_subsys.  It was
> erroneously concluded that net_generic could validly return NULL and
> that net_assign_generic was buggy (when it was just inefficient).
> Hopefully this BUG_ON will prevent people to coming to similar erroneous
> conclusions in the futrue.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Applied.
