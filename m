Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1KXAKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 19:10:30 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40305 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab1KXAK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 19:10:28 -0500
Date: Wed, 23 Nov 2011 19:10:18 -0500 (EST)
Message-Id: <20111123.191018.1357365541804012070.davem@davemloft.net>
To: cascardo@linux.vnet.ibm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-driver@qlogic.com, ron.mercer@qlogic.com,
        jitendra.kalsaria@qlogic.com, anirban.chakraborty@qlogic.com
Subject: Re: [PATCH] qlge: fix size of external list for TX address
 descriptors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322089842-11694-1-git-send-email-cascardo@linux.vnet.ibm.com>
References: <1322089842-11694-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 23 Nov 2011 16:10:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Date: Wed, 23 Nov 2011 21:10:42 -0200

> When transmiting a fragmented skb, qlge fills a descriptor with the
> fragment addresses, after DMA-mapping them. If there are more than eight
> fragments, it will use the eighth descriptor as a pointer to an external
> list. After mapping this external list, called OAL to a structure
> containing more descriptors, it fills it with the extra fragments.
> 
> However, considering that systems with pages larger than 8KiB would have
> less than 8 fragments, which was true before commit a715dea3c8e, it
> defined a macro for the OAL size as 0 in those cases.
> 
> Now, if a skb with more than 8 fragments (counting skb->data as one
> fragment), this would start overwriting the list of addresses already
> mapped and would make the driver fail to properly unmap the right
> addresses on architectures with pages larger than 8KiB.
> 
> Besides that, the list of mappings was one size too small, since it must
> have a mapping for the maxinum number of skb fragments plus one for
> skb->data and another for the OAL. So, even on architectures with page
> sizes 4KiB and 8KiB, a skb with the maximum number of fragments would
> make the driver overwrite its counter for the number of mappings, which,
> again, would make it fail to unmap the mapped DMA addresses.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

Applied, thanks for the detailed commit message.
