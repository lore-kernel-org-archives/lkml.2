Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161008Ab2GKWmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:42:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2GKWme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:42:34 -0400
Date: Wed, 11 Jul 2012 15:42:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, arjan@linux.intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH RESEND] Fix a dead loop in async_synchronize_full()
Message-Id: <20120711154232.165cbca9.akpm@linux-foundation.org>
In-Reply-To: <1341817465.4579.5.camel@ThinkPad-T420>
References: <1341817465.4579.5.camel@ThinkPad-T420>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jul 2012 15:04:25 +0800
Li Zhong <zhong@linux.vnet.ibm.com> wrote:

> This patch tries to fix a dead loop in  async_synchronize_full(), which
> could be seen when preemption is disabled on a single cpu machine. 
> 
> void async_synchronize_full(void)
> {
>         do {
>                 async_synchronize_cookie(next_cookie);
>         } while (!list_empty(&async_running) || !
> list_empty(&async_pending));
> }
> 
> async_synchronize_cookie() calls async_synchronize_cookie_domain() with
> &async_running as the default domain to synchronize. 
> 
> However, there might be some works in the async_pending list from other
> domains. On a single cpu system, without preemption, there is no chance
> for the other works to finish, so async_synchronize_full() enters a dead
> loop. 
> 
> It seems async_synchronize_full() wants to synchronize all entries in
> all running lists(domains), so maybe we could just check the entry_count
> to know whether all works are finished. 
> 
> Currently, async_synchronize_cookie_domain() expects a non-NULL running
> list ( if NULL, there would be NULL pointer dereference ), so maybe a
> NULL pointer could be used as an indication for the functions to
> synchronize all works in all domains. 

The patch is fairly wordwrapped - please fix up your email client.

More seriously, it does not apply to linux-next due to some fairly
significant changes which have been sitting in Dan's tree since May. 
What's going on?

