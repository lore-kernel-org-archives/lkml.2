Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab1CCCXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:23:04 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51330 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab1CCCXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:23:01 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH] Enable writing to /proc/PID/mem.
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1299118074-13342-1-git-send-email-wilsons@start.ca>
References: <1299118074-13342-1-git-send-email-wilsons@start.ca>
Message-Id: <20110303111240.B942.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Mar 2011 11:22:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For a long time /proc/PID/mem has provided a read-only interface, at least since
> 2.4.0.  However, a write capability has existed "forever" in tree via the
> function mem_write, disabled with an #ifdef along with the comment "this is a
> security hazard".  Charles Wright, back in 2006, gave some history on the
> subject:
> 
>     http://lkml.org/lkml/2006/3/10/224
> 
> Later, in commit 638fa202c, Roland McGrath updated mem_write to call
> check_mem_permission which ensures an identical security policy for
> /proc/PID/mem as for ptrace().  IOW, the proc interface provides a simpler, more
> efficient, but otherwise equivalent mechanism for probing a processes memory as
> available via ptrace.
> 
> There is no longer a security hazard and the world can safely use read/write
> instead of ptrace PEEK/POKE's.  Remove the #ifdef.
> 
> Signed-off-by: Stephen Wilson <wilsons@start.ca>

I haven't found any problem in this patch. But, I really believe we need
to understand why it was marked "security hazard". Al, I guess you know it,
right? So, can you please talk us your mention?



