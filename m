Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745Ab1ERTas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:30:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37926 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324Ab1ERTaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:30:46 -0400
Date: Wed, 18 May 2011 15:26:53 -0400 (EDT)
Message-Id: <20110518.152653.1486764697527722925.davem@davemloft.net>
To: tsunanet@gmail.com
Cc: kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: Expose the initial RTO via a new sysctl.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1305715384-81716-1-git-send-email-tsunanet@gmail.com>
References: <1305619677.2850.11.camel@edumazet-laptop>
	<1305715384-81716-1-git-send-email-tsunanet@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 May 2011 12:26:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Sigoure <tsunanet@gmail.com>
Date: Wed, 18 May 2011 03:43:04 -0700

> Instead of hardcoding the initial RTO to 3s and requiring
> the kernel to be recompiled to change it, expose it as a
> sysctl that can be tuned at runtime.  Leave the default
> value unchanged.
> 
> Signed-off-by: Benoit Sigoure <tsunanet@gmail.com>

If you read the ietf draft that reduces the initial RTO down to 1
second, it states that if we take a timeout during the initial
connection handshake then we have to revert the RTO back up to 3
seconds.

This fallback logic conflicts with being able to only change the
initial RTO via sysctl, I think.  Because there are actually two
values at stake and they depend upon eachother, the initial RTO and
the value we fallback to on initial handshake retransmissions.

So I'd rather get a patch that implements the 1 second initial
RTO with the 3 second fallback on SYN retransmit, than this patch.

We already have too many knobs.
