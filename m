Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab0HDWTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 18:19:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303Ab0HDWTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 18:19:36 -0400
Date: Wed, 4 Aug 2010 15:18:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH -mm] hibernation: freeze swap at hibernation v2
Message-Id: <20100804151839.62641a60.akpm@linux-foundation.org>
In-Reply-To: <20100804135739.1d3ed9e2.kamezawa.hiroyu@jp.fujitsu.com>
References: <201007282334.08063.rjw@sisk.pl>
	<20100730131432.891df49a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100802150225.851b48fe.kamezawa.hiroyu@jp.fujitsu.com>
	<201008040109.15818.rjw@sisk.pl>
	<20100804083119.8b7cd3f0.kamezawa.hiroyu@jp.fujitsu.com>
	<20100804135739.1d3ed9e2.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010 13:57:39 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> At taking memory snapshot in hibernate_snapshot(), all (directly called)
> memory allocator uses GFP_ATOMIC. And it seems swap-misusage during
> hibernation never occurs.
> 
> But, from pessimistic point of view, there is no guarantee to trust 
> any page allcation doesn't have __GFP_WAIT. It's better to have an indication
> "we enter hibernation, don't use swap!".
> 
> This patch tries to freeze new-swap-allocation during hibernation.
> (We can trust all user processes are freezed, then, dont't take care of swapin)
> 
> By this, no updates will be happen to swap_map[] among hibernate_snapshot()
> to save_image(). swap is thawed when swsusp_free() is called.
> We can trust swap-corruption will never happen without any doubts.
> 

Confused (as usual).

The above seems to be saying "there isn't a bug, but perhaps there is
one that we don't know about so let's fix it in case it's there".  Or
something.

But this email thread used to be called "Memory corruption during
hibernation since 2.6.31" which sounds a heck of a lot more serious.

Does this patch fix memory corruption?  If so, why was that corruption
occurring, and under which circumstances?

Once all this is known, let's decide whether -stable needs this patch.
