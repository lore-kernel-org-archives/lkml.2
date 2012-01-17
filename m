Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab2AQRbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:31:50 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:55851 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2AQRbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:31:49 -0500
Date: Tue, 17 Jan 2012 12:28:00 -0500 (EST)
Message-Id: <20120117.122800.466698184519541715.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: sivanich@sgi.com, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, paulmck@linux.vnet.ibm.com,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        jkosina@suse.cz, avi@redhat.com, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Fix panic in __d_lookup with high dentry hashtable
 counts
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120117172527.GQ23916@ZenIV.linux.org.uk>
References: <20120113162236.GK23916@ZenIV.linux.org.uk>
	<20120117171352.GA18738@sgi.com>
	<20120117172527.GQ23916@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Jan 2012 09:28:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Tue, 17 Jan 2012 17:25:27 +0000

> On Tue, Jan 17, 2012 at 11:13:52AM -0600, Dimitri Sivanich wrote:
>> When the number of dentry cache hash table entries gets too high
>> (2147483648 entries), as happens by default on a 16TB system, use
>> of a signed integer in the dcache_init() initialization loop prevents
>> the dentry_hashtable from getting initialized, causing a panic in
>> __d_lookup().
>> 
>> In addition, the _hash_mask returned from alloc_large_system_hash() does
>> not support more than a 32 bit hash table size.
>> 
>> Changing the _hash_mask size returned from alloc_large_system_hash() to
>> support larger hash table sizes in the future, and changing loop counter
>> sizes appropriately.
> 
> ... and I still would like to see somebody familiar with uses of other
> hashes to comment on the desirability of such monsters.  For dcache and
> icache it's absolutely certain to be worse than useless.  We are talking
> about 4Gbuckets here...

It's wrong in networking too.
