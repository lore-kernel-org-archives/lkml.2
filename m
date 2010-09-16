Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0IPBim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 21:38:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48937 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0IPBik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 21:38:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Sep 2010 10:33:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC][PATCH] update /proc/sys/vm/drop_caches documentation
Message-Id: <20100916103326.026ca03f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1284600107.20776.640.camel@nimitz>
References: <20100914234714.8AF506EA@kernel.beaverton.ibm.com>
	<20100915133303.0b232671.kamezawa.hiroyu@jp.fujitsu.com>
	<20100915192454.GD5585@tpepper-t61p.dolavim.us>
	<20100916091215.ef59acd7.kamezawa.hiroyu@jp.fujitsu.com>
	<1284600107.20776.640.camel@nimitz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 18:21:47 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Thu, 2010-09-16 at 09:12 +0900, KAMEZAWA Hiroyuki wrote:
> > I hear a customer's case. His server generates 3-80000+ new dentries per day
> > and dentries will be piled up to 1000000+ in a month. This makes open()'s 
> > performance very bad because Hash-lookup will be heavy. (He has very big memory.)
> > 
> > What we could ask him was
> >   - rewrite your application. or
> >   - reboot once in a month (and change hash size) or
> >   - drop_cache once in a month
> > 
> > Because their servers cannot stop, he used drop_caches once in a month
> > while his server is idle, at night. Changing HashSize cannot be a permanent
> > fix because he may not stop the server for years.
> 
> That is a really interesting case.
> 
> They must have a *ton* of completely extra memory laying around.  Do
> they not have much page cache activity? 

I hear they have a ton of extra memory. Just open() slows down.

> It usually balances out the  dentry/inode caches.
> 
> Would this user be better off with a smaller dentry hash in general? 

Maybe. I hear most of files were created-but-never-used data and logs.

> Is it special hardware that should _have_ a lower default hash size?
> 

I'm not sure. I think they have no boot option of hash size.


> > For rare users who have 10000000+ of files and tons of free memory, drop_cache
> > can be an emergency help. 
> 
> In this case, though, would a WARN_ON() in an emergency be such a bad
> thing?  They evidently know what they're doing, and shouldn't be put off
> by it.
> 

Showing "Warning" means ", it's possibly bug." for almost all customers.
We'll get tons of "regression" report ;)

If you really want to add messages, please raise log level.
NOTICE or INFO sounds better(and moderate) to me because it's easy to explain
"Don't worry about the message, your kernel is stable and don't need to reboot.
 But please check the peformance, it tends to go bad. You lose cache.".
BTW, what(1or2or3) was writtern to "drop_cache" is important. please show.

Thanks,
-Kame







