Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1KQWWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:22:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1KQWWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:22:15 -0500
Date: Thu, 17 Nov 2011 14:22:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Miao Xie <miaox@cn.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.2-rc3] cpusets: stall when updating mems_allowed
 for mempolicy or disjoint nodemask
Message-Id: <20111117142213.2b34469d.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1111161307020.23629@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1111161307020.23629@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011 13:08:33 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> c0ff7453bb5c ("cpuset,mm: fix no node to alloc memory when changing
> cpuset's mems") adds get_mems_allowed() to prevent the set of allowed
> nodes from changing for a thread.  This causes any update to a set of
> allowed nodes to stall until put_mems_allowed() is called.
> 
> This stall is unncessary, however, if at least one node remains unchanged
> in the update to the set of allowed nodes.  This was addressed by
> 89e8a244b97e ("cpusets: avoid looping when storing to mems_allowed if one
> node remains set"), but it's still possible that an empty nodemask may be
> read from a mempolicy because the old nodemask may be remapped to the new
> nodemask during rebind.  To prevent this, only avoid the stall if there
> is no mempolicy for the thread being changed.
> 
> This is a temporary solution until all reads from mempolicy nodemasks can
> be guaranteed to not be empty without the get_mems_allowed()
> synchronization.
> 
> Also moves the check for nodemask intersection inside task_lock() so that
> tsk->mems_allowed cannot change.

The patch doesn't actually apply, due to changes made by your earlier
89e8a244b97e ("cpusets: avoid looping when storing to mems_allowed if
one node remains set").  Please recheck/redo/resend/etc?
