Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0LASKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:10:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:36558 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0LASKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:10:19 -0500
Date: Wed, 1 Dec 2010 16:10:01 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com
Subject: Re: [PATCH] perf: add csv-style output to perf stat (v2)
Message-ID: <20101201181001.GA26071@ghostprotocols.net>
References: <4cf68aa7.0fedd80a.5294.1203@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cf68aa7.0fedd80a.5294.1203@mx.google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 01, 2010 at 06:49:05PM +0200, Stephane Eranian escreveu:
> This patch adds an option (-x/--field-separator) to print counts using
> a CSV-style output. The user can pass a custom separator. This makes it
> very easy to import counts directly into your favorite spreadsheet without
> having to write scripts.
> 
> Example:
> $ perf stat --field-separator=,  -a -- sleep 1
> 4009.961740,task-clock-msecs
> 13,context-switches
> 2,CPU-migrations
> 189,page-faults
> 9596385684,cycles
> 3493659441,instructions
> 872897069,branches
> 41562,branch-misses
> 22424,cache-references
> 1289,cache-misses

[root@mica ~]# perf stat -x,  -a -A -- sleep 1
-B option not supported with -x

 usage: perf stat [<options>] [<command>]

    -e, --event <event>   event selector. use 'perf list' to list
available events
    -i, --no-inherit      child tasks do not inherit counters
    -p, --pid <n>         stat events on existing process id


Guess we'll have to disable big_num automatically when -x is specified,
but at the same time notice if the user _explicitely_ asked for -B.

I'll fix this now.

- Arnaldo
