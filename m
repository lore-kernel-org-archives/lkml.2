Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab2ALU2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:28:22 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40740 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab2ALU2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:28:19 -0500
Date: Thu, 12 Jan 2012 12:28:16 -0800 (PST)
Message-Id: <20120112.122816.1727420253535508242.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH] net: decrement memcg jump label when limit, not usage,
 is changed
From: David Miller <davem@davemloft.net>
In-Reply-To: <1326370566-4286-1-git-send-email-glommer@parallels.com>
References: <1326370566-4286-1-git-send-email-glommer@parallels.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 Jan 2012 12:28:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Thu, 12 Jan 2012 16:16:06 +0400

> The logic of the current code is that whenever we destroy
> a cgroup that had its limit set (set meaning different than
> maximum), we should decrement the jump_label counter.
> Otherwise we assume it was never incremented.
> 
> But what the code actually does is test for RES_USAGE
> instead of RES_LIMIT. Usage being different than maximum
> is likely to be true most of the time.
> 
> The effect of this is that the key must become negative,
> and since the jump_label test says:
> 
>         !!atomic_read(&key->enabled);
> 
> we'll have jump_labels still on when no one else is
> using this functionality.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: David S. Miller <davem@davemloft.net>

Applied, thanks.
