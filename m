Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab0KWWXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 17:23:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369Ab0KWWXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 17:23:14 -0500
Date: Tue, 23 Nov 2010 14:22:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutsemov" <kirill@shutemov.name>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [BUG] memcg: fix false positive VM_BUG on non-SMP
Message-Id: <20101123142247.e8566e3e.akpm@linux-foundation.org>
In-Reply-To: <20101123210255.GA22484@cmpxchg.org>
References: <1290520130-9990-1-git-send-email-kirill@shutemov.name>
	<20101123121606.c07197e5.akpm@linux-foundation.org>
	<20101123210255.GA22484@cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 22:02:55 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Tue, Nov 23, 2010 at 12:16:06PM -0800, Andrew Morton wrote:
> > On Tue, 23 Nov 2010 15:48:50 +0200
> > "Kirill A. Shutsemov" <kirill@shutemov.name> wrote:
> > 
> > > ------------[ cut here ]------------
> > > kernel BUG at mm/memcontrol.c:2155!
> > 
> > This bug has been there for a year, from which I conclude people don't
> > run memcg on uniprocessor machines a lot.
> > 
> > Which is a bit sad, really.  Small machines need resource control too,
> > perhaps more than large ones..
> 
> Admittedly, this patch is compile-tested on UP only, but it should be
> obvious enough.
> 
> ---
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: [patch] memcg: fix page cgroup lock assert on UP
> 
> Page cgroup locking primitives use the bit spinlock API functions,
> which do nothing on UP.
> 
> Thus, checking the lock state can not be done by looking at the bit
> directly, but one has to go through the bit spinlock API as well.
> 
> This fixes a guaranteed UP bug, where asserting the page cgroup lock
> bit as a sanity check crashes the kernel.
> 

hm, your patch is the same as Kirill's, except you named it
page_is_cgroup_locked() rather than is_page_cgroup_locked().  I guess
page_is_cgroup_locked() is a bit better.

