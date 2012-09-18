Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2IRUQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:16:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46704 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2IRUQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:16:18 -0400
Date: Tue, 18 Sep 2012 16:16:15 -0400 (EDT)
Message-Id: <20120918.161615.2073424715014606822.davem@davemloft.net>
To: steffen.klassert@secunet.com
Cc: minipli@googlemail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfrm_user: return error pointer instead of NULL
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120917071642.GC13023@secunet.com>
References: <1347572486-1628-1-git-send-email-minipli@googlemail.com>
	<20120917071642.GC13023@secunet.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Mon, 17 Sep 2012 09:16:42 +0200

> On Thu, Sep 13, 2012 at 11:41:26PM +0200, Mathias Krause wrote:
>> When dump_one_state() returns an error, e.g. because of a too small
>> buffer to dump the whole xfrm state, xfrm_state_netlink() returns NULL
>> instead of an error pointer. But its callers expect an error pointer
>> and therefore continue to operate on a NULL skbuff.
>> 
>> This could lead to a privilege escalation (execution of user code in
>> kernel context) if the attacker has CAP_NET_ADMIN and is able to map
>> address 0.
> 
> Or it simply crashes with a NULL pointer dereference.
> 
>> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> 
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Applied, and queued up for -stable.

Please do not CC: stable explicitly in your patch submissions,
I removed it from the patch.

Instead, ask me to queue the patch up for -stable.  We handle stable
submissed via a patch queue which I maintain at:

	http://patchwork.ozlabs.org/user/bundle/2566/?state=*

so that I can let patches cook in Linus's tree for a length of
time of my choosing, rather than having bug fixes automatically
propagate the moment it hits Linus's tree.

Thanks.
