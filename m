Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab1ELVJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:09:24 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56305 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758633Ab1ELVJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:09:23 -0400
Date: Thu, 12 May 2011 17:08:45 -0400 (EDT)
Message-Id: <20110512.170845.1074260586094306244.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, eranian@google.com, acme@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsprintf: Turn kptr_restrict off by default
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110512210028.GA16600@elte.hu>
References: <BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
	<20110512.164319.1770509419224900253.davem@davemloft.net>
	<20110512210028.GA16600@elte.hu>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 May 2011 14:08:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 12 May 2011 23:00:28 +0200

> Subject: vsprintf: Turn kptr_restrict off by default
> 
> kptr_restrict has been triggering bugs in apps such as perf, and it also makes 
> the system less useful by default, so turn it off by default.
> 
> This is how we generally handle security features that remove functionality, 
> such as firewall code or SELinux - they have to be configured and activated 
> from user-space.
> 
> Distributions can turn kptr_restrict on again via this line in 
> /etc/sysctrl.conf:
> 
> kernel.kptr_restrict = 1
> 
> ( Also mark the variable __read_mostly while at it, as it's typically modified 
>   only once per bootup, or not at all. )
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: David S. Miller <davem@davemloft.net>
