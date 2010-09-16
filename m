Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0IPBVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 21:21:52 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40618 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab0IPBVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 21:21:51 -0400
Subject: Re: [RFC][PATCH] update /proc/sys/vm/drop_caches documentation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20100916091215.ef59acd7.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100914234714.8AF506EA@kernel.beaverton.ibm.com>
	 <20100915133303.0b232671.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100915192454.GD5585@tpepper-t61p.dolavim.us>
	 <20100916091215.ef59acd7.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Wed, 15 Sep 2010 18:21:47 -0700
Message-ID: <1284600107.20776.640.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 09:12 +0900, KAMEZAWA Hiroyuki wrote:
> I hear a customer's case. His server generates 3-80000+ new dentries per day
> and dentries will be piled up to 1000000+ in a month. This makes open()'s 
> performance very bad because Hash-lookup will be heavy. (He has very big memory.)
> 
> What we could ask him was
>   - rewrite your application. or
>   - reboot once in a month (and change hash size) or
>   - drop_cache once in a month
> 
> Because their servers cannot stop, he used drop_caches once in a month
> while his server is idle, at night. Changing HashSize cannot be a permanent
> fix because he may not stop the server for years.

That is a really interesting case.

They must have a *ton* of completely extra memory laying around.  Do
they not have much page cache activity?  It usually balances out the
dentry/inode caches.

Would this user be better off with a smaller dentry hash in general?  Is
it special hardware that should _have_ a lower default hash size?

> For rare users who have 10000000+ of files and tons of free memory, drop_cache
> can be an emergency help. 

In this case, though, would a WARN_ON() in an emergency be such a bad
thing?  They evidently know what they're doing, and shouldn't be put off
by it.

-- Dave

