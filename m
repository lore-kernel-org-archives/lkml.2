Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab2BQVB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:01:58 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54717 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab2BQVB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:01:56 -0500
Date: Fri, 17 Feb 2012 16:01:47 -0500 (EST)
Message-Id: <20120217.160147.1731660099441103969.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: benve@cisco.com, dkukawka@suse.de, roprabhu@cisco.com, dwang2@cisco.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/10] cisco/enic: use eth_hw_addr_random() instead
 of random_ether_addr()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329493411-25750-8-git-send-email-danny.kukawka@bisect.de>
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
	<1329493411-25750-8-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Feb 2012 13:01:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Fri, 17 Feb 2012 16:43:28 +0100

> Use dev_hw_addr_random() instead of calling random_ether_addr()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.
> 
> Couldn't replace random_ether_addr() in enic_probe() since
> enic_set_mac_addr() is used which would reset addr_assign_type.
> Instead set addr_assign_type directly to NET_ADDR_RANDOM in
> case of random mac after call enic_set_mac_addr().
> 
> Reset the state to NET_ADDR_PERM as soon as the MAC get
> changed via .ndo_set_mac_address.
> 
> v2: use bitops, adapt to eth_hw_addr_random(), add a comment
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

This patch doesn't apply at all to the current net-next tree,
please always validate that your patches actually apply to the
tree before submission.
