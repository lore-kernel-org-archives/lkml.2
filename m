Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab2EIO41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:56:27 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58952 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850Ab2EIO4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:56:25 -0400
Date: Wed, 9 May 2012 11:56:19 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] perf record: fix fallback to cpu-clock on ppc
Message-ID: <20120509145619.GM2485@infradead.org>
References: <1336452004-55724-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336452004-55724-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 07, 2012 at 10:40:04PM -0600, David Ahern escreveu:
> perf-record on PPC is not falling back to cpu-clock:
> 
> Old kernel, cannot exclude guest or host samples.
> 
>   Error: sys_perf_event_open() syscall returned with 6 (No such device or address).  /bin/dmesg may provide additional information.
> 
>   Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
> 
> The problem is that until 2.6.37 (behavior changed with commit b0a873e)
> perf on PPC returns ENXIO when hw_perf_event_init() fails. With this
> patch we get the expected behavior:
> 
> Old kernel, cannot exclude guest or host samples.
> The cycles event is not supported, trying to fall back to cpu-clock-ticks
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.150 MB /tmp/perf.data (~6569 samples) ]

Thanks, applied to my perf/core branch.

Can you please provide one for perf/urgent?

- Arnaldo
