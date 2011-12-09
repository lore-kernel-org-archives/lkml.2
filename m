Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab1LIRL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:11:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43644 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab1LIRLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:11:54 -0500
Date: Fri, 9 Dec 2011 21:11:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111209171149.GU21678@moon>
References: <20111206181026.GO29781@moon>
 <20111207185343.GA3209@redhat.com>
 <20111207190340.GP21678@moon>
 <20111208163535.GA25023@redhat.com>
 <20111208212853.GO21678@moon>
 <20111208135430.00730308.akpm@linux-foundation.org>
 <20111209153009.GA20865@redhat.com>
 <20111209154930.GT21678@moon>
 <20111209165536.GA25268@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111209165536.GA25268@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 05:55:36PM +0100, Oleg Nesterov wrote:
...
> 
> To simplify, let's talk about children_seq_start() your patch adds.
> Suppose that we make ->children/sibling "rcu-safe" (we replace
> __unhash_process()->list_del_init() with list_del_rcu, and so on).
> 
> Now, children_seq_start() does:
> 
> 	rcu_read_lock();
> 
> 	list_for_each(child, task->children)
> 		...;
> 
> Suppose that this task exits and reparents the child we are looking at.
> Once reparent_leader() moves it into another list, list_for_each()
> can never stop.
> 
> In short. forget_original_parent() changes the _head_ of the list,
> in some sense.
> 

Yeah, I missed this, my bad! Thanks for explanation, Oleg. I'll
post updated version once I finish it.

	Cyrill
