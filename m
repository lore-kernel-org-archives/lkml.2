Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2E3R1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:27:31 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50955 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2E3R13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:27:29 -0400
Date: Wed, 30 May 2012 14:27:24 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: Re: [PATCH] perf script: fix regression in dso name
Message-ID: <20120530172724.GC12477@infradead.org>
References: <1338353906-60706-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338353906-60706-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 29, 2012 at 10:58:26PM -0600, David Ahern escreveu:
> $ perf script -i /tmp/perf.data
> ...
> gcc 13623 544315.062858: context-switches:
>     ffffffff815f65c9 __schedule ([kernel.kallsyms])
>     ffffffff81087cea __cond_resched ([kernel.kallsyms])
>     ffffffff815f6b92 _cond_resched ([kernel.kallsyms])
>     ffffffff815fb87a do_page_fault ([kernel.kallsyms])
>     ffffffff815f8465 page_fault ([kernel.kallsyms])
>         2b7a71ea0303 _dl_lookup_symbol_x ([kernel.kallsyms])
>         2b7a71ea1eb5 _dl_relocate_object ([kernel.kallsyms])
>         2b7a71e99b2e dl_main ([kernel.kallsyms])
>         2b7a71eab7f4 _dl_sysdep_start ([kernel.kallsyms])
> 
> All DSO's in a callchain are printed as [kernel.kallsyms].

Thanks, reproduced, tested and pushed to perf/urgent.

Unfortunately saw this after the last pull req, will include it in the
next if Ingo pulls from the signed tag instead of perf/urgent.

- Arnaldo
