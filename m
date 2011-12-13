Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab1LMW6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 17:58:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab1LMW6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 17:58:52 -0500
Date: Tue, 13 Dec 2011 14:58:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        rientjes@google.com
Subject: Re: [PATCH v4] oom: add trace points for debugging.
Message-Id: <20111213145851.c7e5d8fa.akpm@linux-foundation.org>
In-Reply-To: <20111213181225.673e19db.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111213181225.673e19db.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011 18:12:25 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Changelog:
>  - devided into oom tracepoint and task tracepoint.
>  - task tracepoint traces fork/rename
>  - oom tracepoint traces modification to oom_score_adj.
> 
> dropped acks because of total design changes.
> 
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Subject: [PATCH] tracepoint: add tracepoints for debugging oom_score_adj.
> 
> oom_score_adj is used for guarding processes from OOM-Killer. One of problem
> is that it's inherited at fork(). When a daemon set oom_score_adj and
> make children, it's hard to know where the value is set.

This sounds like a really thin justification for patching the kernel. 
"Help! I don't know what my code is doing!".

Alternatives would include grepping your source code for
"oom_score_adj", or running "strace -f"!

I suspect you did have a good reason for making this change, but it
wasn't explained very well?

