Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab3AHDPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 22:15:09 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:55574 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3AHDPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 22:15:04 -0500
Date: Mon, 7 Jan 2013 19:15:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jason Liu <r64343@freescale.com>
cc: linux-kernel@vger.kernel.org, mgorman@suse.de, akpm@linux-foundation.org,
        riel@redhat.com, minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: compaction: fix echo 1 > compact_memory return error
 issue
In-Reply-To: <1357458273-28558-1-git-send-email-r64343@freescale.com>
Message-ID: <alpine.DEB.2.00.1301071914460.18525@chino.kir.corp.google.com>
References: <1357458273-28558-1-git-send-email-r64343@freescale.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2013, Jason Liu wrote:

> when run the folloing command under shell, it will return error
> sh/$ echo 1 > /proc/sys/vm/compact_memory
> sh/$ sh: write error: Bad address
> 
> After strace, I found the following log:
> ...
> write(1, "1\n", 2)               = 3
> write(1, "", 4294967295)         = -1 EFAULT (Bad address)
> write(2, "echo: write error: Bad address\n", 31echo: write error: Bad address
> ) = 31
> 
> This tells system return 3(COMPACT_COMPLETE) after write data to compact_memory.
> 
> The fix is to make the system just return 0 instead 3(COMPACT_COMPLETE) from
> sysctl_compaction_handler after compaction_nodes finished.
> 
> Suggested-by:David Rientjes <rientjes@google.com>
> Cc:Mel Gorman <mgorman@suse.de>
> Cc:Andrew Morton <akpm@linux-foundation.org>
> Cc:Rik van Riel <riel@redhat.com>
> Cc:Minchan Kim <minchan@kernel.org>
> Cc:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Jason Liu <r64343@freescale.com>

Acked-by: David Rientjes <rientjes@google.com>
