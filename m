Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab1LMXx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 18:53:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46703 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab1LMXxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 18:53:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 14 Dec 2011 08:52:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        rientjes@google.com
Subject: Re: [PATCH v4] oom: add trace points for debugging.
Message-Id: <20111214085236.42c02bda.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111213145851.c7e5d8fa.akpm@linux-foundation.org>
References: <20111213181225.673e19db.kamezawa.hiroyu@jp.fujitsu.com>
	<20111213145851.c7e5d8fa.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011 14:58:51 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 13 Dec 2011 18:12:25 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > Changelog:
> >  - devided into oom tracepoint and task tracepoint.
> >  - task tracepoint traces fork/rename
> >  - oom tracepoint traces modification to oom_score_adj.
> > 
> > dropped acks because of total design changes.
> > 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Subject: [PATCH] tracepoint: add tracepoints for debugging oom_score_adj.
> > 
> > oom_score_adj is used for guarding processes from OOM-Killer. One of problem
> > is that it's inherited at fork(). When a daemon set oom_score_adj and
> > make children, it's hard to know where the value is set.
> 
> This sounds like a really thin justification for patching the kernel. 
> "Help! I don't know what my code is doing!".
> 
> Alternatives would include grepping your source code for
> "oom_score_adj", or running "strace -f"!
> 
> I suspect you did have a good reason for making this change, but it
> wasn't explained very well?
> 

Ah, one example is this thread.
- http://marc.info/?t=132273239800008&r=1&w=4
oom_score_adj was inherited by sshd by bug?

And IIUC, I saw other issues with other task launchers as Gnome.

If the problem is caused by some daemon, strace -f is not very good.
And the user will not have the source codes. So, I thought it's better
to have tracepoints to see what is wrong in application chains.


Thanks,
-Kame


