Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2GDGno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:43:44 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62319 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab2GDGnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:43:43 -0400
Date: Tue, 3 Jul 2012 23:43:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cong Wang <amwang@redhat.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org
Subject: Re: [Patch] mm/policy: use int instead of unsigned for nid
In-Reply-To: <1341370901-14187-1-git-send-email-amwang@redhat.com>
Message-ID: <alpine.DEB.2.00.1207032342120.32556@chino.kir.corp.google.com>
References: <1341370901-14187-1-git-send-email-amwang@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2012, Cong Wang wrote:

> From: WANG Cong <xiyou.wangcong@gmail.com>
> 
> 'nid' should be 'int', not 'unsigned'.
> 

unsigned is already of type int, so you're saying these occurrences should 
become signed, but that's not true since they never return NUMA_NO_NODE.  
They are all safe returning unsigned.

And alloc_page_interleave() doesn't exist anymore since the sched/numa 
bits were merged into sched/core, so nobody could apply this patch anyway.
