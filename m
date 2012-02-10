Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050Ab2BJT7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:59:07 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36301 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2BJT7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:59:06 -0500
Date: Fri, 10 Feb 2012 17:58:58 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf tools: Allow multiple threads or processes in
 record, stat, top
Message-ID: <20120210195857.GM2526@infradead.org>
References: <1328718772-16688-1-git-send-email-dsahern@gmail.com>
 <20120210192402.GJ2526@infradead.org>
 <4F3570B9.5090708@gmail.com>
 <20120210193429.GL2526@infradead.org>
 <4F357420.6030603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F357420.6030603@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 10, 2012 at 12:46:40PM -0700, David Ahern escreveu:
> On 02/10/2012 12:34 PM, Arnaldo Carvalho de Melo wrote:
> > I assume you tested it in a few scenarios (I know I did, but hey, more
> > testing is always good) and that I can add another stamp, a Tested-by:
> > ya, right?
> > 
> > - Arnaldo
> 
> Hmmm... that was a radical idea. Build breaks on Fedora 16, x86_64:
> 
> util/thread_map.c: In function ‘thread_map__new_by_pid_str’:
> util/thread_map.c:164:2: error: overflow in implicit constant conversion
> [-Werror=overflow]
> util/thread_map.c:175:3: error: comparison is always false due to
> limited range of data type [-Werror=type-limits]
> util/thread_map.c:175:3: error: comparison is always false due to
> limited range of data type [-Werror=type-limits]
> util/thread_map.c: In function ‘thread_map__new_by_tid_str’:
> util/thread_map.c:223:2: error: overflow in implicit constant conversion
> [-Werror=overflow]
> util/thread_map.c:245:3: error: comparison is always false due to
> limited range of data type [-Werror=type-limits]
> util/thread_map.c:245:3: error: comparison is always false due to
> limited range of data type [-Werror=type-limits]
> cc1: all warnings being treated as errors
> 
> 
> I think you want INT_MAX not LONG_MAX.

yeah, I tested it only on 32-bit :-\

I'll re-read the strtol man page and rework this patch, thanks for
testing!

- Arnaldo
