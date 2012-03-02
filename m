Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab2CBVNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:13:44 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:58590 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab2CBVNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:13:42 -0500
Date: Fri, 02 Mar 2012 16:13:32 -0500 (EST)
Message-Id: <20120302.161332.2236794166581618113.davem@davemloft.net>
To: santoshprasadnayak@gmail.com
Cc: bhutchings@solarflare.com, jitendra.kalsaria@qlogic.com,
        ron.mercer@qlogic.com, linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] qla3xxx: ethernet: Fix bogus interrupt state flag.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAOD=uF5ebyA-yd8T8nXd9vYRw1yvFKVQd9TmcBwMnxFs6enKvA@mail.gmail.com>
References: <1330700945-18195-1-git-send-email-santoshprasadnayak@gmail.com>
	<1330702146.2611.1.camel@bwh-desktop>
	<CAOD=uF5ebyA-yd8T8nXd9vYRw1yvFKVQd9TmcBwMnxFs6enKvA@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 02 Mar 2012 13:13:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: santosh prasad nayak <santoshprasadnayak@gmail.com>
Date: Fri, 2 Mar 2012 21:24:29 +0530

> In "ql_adapter_initialize", first unlock is done by
> "spin_unlock_irqrestore(&qdev->hw_lock, hw_flags)"
> with "hw_flags = 0"   ("hw_flags" is local variable and initialized to
> zero.),   which is as good as
> spin_unlock_irq.

You must never pass to irqrestore anything other than a hw_flags
value given by irqsave or similar.

You may not assume anything about what values hw_flags takes on nor
what those values might mean, they are architecture specific so
you may not just set it to zero and assume that does anything in
particular.
