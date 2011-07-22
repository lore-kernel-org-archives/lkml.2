Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab1GVEaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 00:30:07 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40157 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab1GVEaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 00:30:05 -0400
Date: Thu, 21 Jul 2011 21:29:50 -0700 (PDT)
Message-Id: <20110721.212950.1991725607632413241.davem@davemloft.net>
To: mst@redhat.com
Cc: krkumar2@in.ibm.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, shemminger@vyatta.com
Subject: Re: [PATCH repost] Fix panic in virtnet_remove
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110720143115.GB6787@redhat.com>
References: <20110720135602.18705.21405.sendpatchset@krkumar2.in.ibm.com>
	<20110720143115.GB6787@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 21 Jul 2011 21:29:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 20 Jul 2011 17:31:15 +0300

> On Wed, Jul 20, 2011 at 07:26:02PM +0530, Krishna Kumar wrote:
>> Fix a panic in virtnet_remove. unregister_netdev has already
>> freed up the netdev (and virtnet_info) due to dev->destructor
>> being set, while virtnet_info is still required. Remove
>> virtnet_free altogether, and move the freeing of the per-cpu
>> statistics from virtnet_free to virtnet_remove.
>> 
>> Tested patch below.
>> 
>> Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
> 
> Also note that the crash was apparently introduced by
> 3fa2a1df909482cc234524906e4bd30dee3514df in net-next,
> so this is a net-next only patch.
> 
> Stephen, was there any special reason to free the memory
> in the destructor like you did?
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Applied.
