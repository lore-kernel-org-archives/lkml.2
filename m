Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0ELHef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 03:34:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187Ab0ELHed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 03:34:33 -0400
Date: Wed, 12 May 2010 00:32:46 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: miaox@cn.fujitsu.com
Cc: David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH -mm] cpuset,mm: fix no node to alloc memory when
 changing cpuset's mems - fix2
Message-Id: <20100512003246.9f0ee03c.akpm@linux-foundation.org>
In-Reply-To: <4BEA56D3.6040705@cn.fujitsu.com>
References: <4BEA56D3.6040705@cn.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 15:20:51 +0800 Miao Xie <miaox@cn.fujitsu.com> wrote:

> @@ -985,6 +984,7 @@ repeat:
>  	 * for the read-side.
>  	 */
>  	while (ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
> +		task_unlock(tsk);
>  		if (!task_curr(tsk))
>  			yield();
>  		goto repeat;

Oh, I meant to mention that.  No yield()s, please.  Their duration is
highly unpredictable.  Can we do something more deterministic here?

Did you consider doing all this with locking?  get_mems_allowed() does
mutex_lock(current->lock)?

