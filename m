Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab2AMQQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 11:16:01 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36555 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758267Ab2AMQPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 11:15:50 -0500
Message-ID: <1326471346.3826.23.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] Fix panic in __d_lookup with high dentry hashtable
 counts
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Avi Kivity <avi@redhat.com>,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Date: Fri, 13 Jan 2012 17:15:46 +0100
In-Reply-To: <20120113155237.GA25103@sgi.com>
References: <20120113155237.GA25103@sgi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 13 janvier 2012 à 09:52 -0600, Dimitri Sivanich a écrit :
> When the number of dentry cache hash table entries gets too high
> (2147483648 entries), use of a signed integer in the initialization
> loop prevents the dentry_hashtable from getting initialized, resulting
> in a panic in __d_lookup.  Fixing this in dcache_init and a few other
> spots for consistency.

Well...

nr_dentry being an int, I dont think having a so big hash table is
needed/possible. Its probably a waste of memory ?

Maybe we should limit alloc_large_system_hash() to at most 2^30 slots.

[ And later, convert it to unsigned long *_hash_shift and unsigned long
*_hash_mask ]



