Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750938Ab2ARFAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 00:00:44 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33161 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2ARFAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 00:00:42 -0500
Date: Tue, 17 Jan 2012 23:57:39 -0500 (EST)
Message-Id: <20120117.235739.1691577461093505587.davem@davemloft.net>
To: sivanich@sgi.com
Cc: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        eric.dumazet@gmail.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, paulmck@linux.vnet.ibm.com,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        jkosina@suse.cz, avi@redhat.com, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Fix panic in __d_lookup with high dentry hashtable
 counts
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120117210541.GA21940@sgi.com>
References: <20120117171352.GA18738@sgi.com>
	<20120117.122229.323838457367599504.davem@davemloft.net>
	<20120117210541.GA21940@sgi.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Jan 2012 20:57:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dimitri Sivanich <sivanich@sgi.com>
Date: Tue, 17 Jan 2012 15:05:41 -0600

> On Tue, Jan 17, 2012 at 12:22:29PM -0500, David Miller wrote:
>> To be honest I think this is overkill.
>> 
>> Supporting anything larger than a 32-bit hash mask is not even close
>> to being reasonable.  Nobody needs a 4GB hash table, not for anything.
>>
> Here is a patch that keeps the 32-bit hash mask.
> 
> 
>  
> When the number of dentry cache hash table entries gets too high
> (2147483648 entries), as happens by default on a 16TB system, use
> of a signed integer in the dcache_init() initialization loop prevents
> the dentry_hashtable from getting initialized, causing a panic in
> __d_lookup().  Fix this in dcache_init() and similar areas.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

This looks good to me, thanks Dimitri:

Acked-by: David S. Miller <davem@davemloft.net>
