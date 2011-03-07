Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab1CGVxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:53:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755246Ab1CGVxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:53:10 -0500
Date: Mon, 7 Mar 2011 13:52:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Vagin <avagin@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: skip zombie in OOM-killer
Message-Id: <20110307135228.aad5a97d.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1103071234480.10264@chino.kir.corp.google.com>
References: <1299286307-4386-1-git-send-email-avagin@openvz.org>
	<20110306193519.49DD.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1103061400170.23737@chino.kir.corp.google.com>
	<AANLkTi=d+eZxg_NgNWa7roo=1YQS06=EaWJzjseL_Hhs@mail.gmail.com>
	<alpine.DEB.2.00.1103071234480.10264@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Mar 2011 12:36:49 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 7 Mar 2011, Andrew Vagin wrote:
> 
> > > Andrey is patching the case where an eligible TIF_MEMDIE process is found
> > > but it has already detached its ->mm. __In combination with the patch
> > > posted to linux-mm, oom: prevent unnecessary oom kills or kernel panics,
> > > which makes select_bad_process() iterate over all threads, it is an
> > > effective solution.
> > 
> > Probably you said about the first version of my patch.
> > This version is incorrect because of
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dd8e8f405ca386c7ce7cbb996ccd985d283b0e03
> > 
> > but my first patch is correct and it has a simple reproducer(I
> > attached it). You can execute it and your kernel hangs up, because the
> > parent doesn't wait children, but the one child (zombie) will have
> > flag TIF_MEMDIE, oom_killer will kill nobody
> > 
> 
> The second version of your patch works fine in combination with the 
> pending "oom: prevent unnecessary oom kills or kernel panics" patch from 
> linux-mm (included below).

Andrew's v2 doesn't apply on top of
oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch and I'm
disinclined to fix that up and merge some untested patch combination.

