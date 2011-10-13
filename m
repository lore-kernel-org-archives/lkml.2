Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab1JMUMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:12:35 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52233 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1JMUMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:12:33 -0400
Date: Thu, 13 Oct 2011 16:12:21 -0400 (EDT)
Message-Id: <20111013.161221.1969725742975317077.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        ebiederm@xmission.com, paul@paulmenage.org, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        avagin@parallels.com, devel@openvz.org
Subject: Re: [PATCH v7 0/8] Request for inclusion: tcp memory buffers
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E9744A6.5010101@parallels.com>
References: <1318511382-31051-1-git-send-email-glommer@parallels.com>
	<20111013.160031.605700447623532119.davem@davemloft.net>
	<4E9744A6.5010101@parallels.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 13 Oct 2011 13:12:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Fri, 14 Oct 2011 00:05:58 +0400

> Also, I kind of dispute the affirmation that !cgroup will encompass
> the majority of users, since cgroups is being enabled by default by
> most vendors. All systemd based systems use it extensively, for
> instance.

I will definitely advise people against this, since the cost of having
this on by default is absolutely non-trivial.

People keep asking every few releases "where the heck has my performance
gone" and it's because of creeping features like this.  This socket
cgroup feature is a prime example of where that kind of stuff comes
from.

I really get irritated when people go "oh, it's just one indirect
function call" and "oh, it's just one more pointer in struct sock"

We work really hard to _remove_ elements from structures and make them
smaller, and to remove expensive operations from the fast paths.

It might take someone weeks if not months to find a way to make a
patch which compensates for the extra overhead your patches are adding.

And I don't think you fully appreciate that.
