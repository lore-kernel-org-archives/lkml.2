Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab2CHCHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 21:07:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab2CHCHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 21:07:16 -0500
Date: Wed, 7 Mar 2012 18:09:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 1/2] mm, counters: remove task argument to sync_mm_rss
 and __sync_task_rss_stat
Message-Id: <20120307180917.7d570d95.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1203071739150.26591@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1203061919260.21806@chino.kir.corp.google.com>
	<20120307171155.f9bb71b6.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1203071739150.26591@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012 17:40:04 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> On Wed, 7 Mar 2012, Andrew Morton wrote:
> 
> > hm, with my gcc it's beneficial to cache `current' in a local.  But
> > when I tried that, Weird Things happened, because gcc has gone and
> > decided to inline __sync_task_rss_stat() into its callers.  I don't see
> > how that could have been the right thing to do.
> > 
> 
> c06b1fca18c3 offers some advice :)

But is it right?  I handled a patch a month or two ago where caching
current made a nice improvement.

