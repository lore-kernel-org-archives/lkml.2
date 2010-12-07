Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab0LGG5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 01:57:07 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:19755 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752433Ab0LGG5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 01:57:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAC1o/Ux5LdIm/2dsb2JhbACjNnLAA4VJBJAH
Date: Tue, 7 Dec 2010 17:56:59 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [RFC][PATCH 05/10] mm: Remove likely() from
  grab_cache_page_write_begin()
Message-ID: <20101207065659.GA3307@amd>
References: <20101207015834.196176991@goodmis.org>
 <20101207021329.476854013@goodmis.org>
 <1291688650.16223.124.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291688650.16223.124.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 09:24:10PM -0500, Steven Rostedt wrote:
> [ Resending to Nick's real email address ]
> 
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Running the annotated branch profiler on a box doing average work
> (firefox, evolution, xchat, distcc farm), the likely() used in
> grab_cache_page_write_begin() was incorrect most of the time:
> 
>  correct incorrect  %        Function                  File              Line
>  ------- ---------  -        --------                  ----              ----
>  1924262 71332401  97 grab_cache_page_write_begin    filemap.c           2206
> 
> Adding a trace_printk() and running the function tracer limited to
> just this function I can see:
> 
>         gconfd-2-2696  [000]  4467.268935: grab_cache_page_write_begin: page=          (null) mapping=ffff8800676a9460 index=7
>         gconfd-2-2696  [000]  4467.268946: grab_cache_page_write_begin <-ext3_write_begin
>         gconfd-2-2696  [000]  4467.268947: grab_cache_page_write_begin: page=          (null) mapping=ffff8800676a9460 index=8
>         gconfd-2-2696  [000]  4467.268959: grab_cache_page_write_begin <-ext3_write_begin
>         gconfd-2-2696  [000]  4467.268960: grab_cache_page_write_begin: page=          (null) mapping=ffff8800676a9460 index=9
>         gconfd-2-2696  [000]  4467.268972: grab_cache_page_write_begin <-ext3_write_begin
>         gconfd-2-2696  [000]  4467.268973: grab_cache_page_write_begin: page=          (null) mapping=ffff8800676a9460 index=10
>         gconfd-2-2696  [000]  4467.268991: grab_cache_page_write_begin <-ext3_write_begin
>         gconfd-2-2696  [000]  4467.268992: grab_cache_page_write_begin: page=          (null) mapping=ffff8800676a9460 index=11
>         gconfd-2-2696  [000]  4467.269005: grab_cache_page_write_begin <-ext3_write_begin
> 
> Which shows that a lot of calls from ext3_write_begin will result in
> the page returned by "find_lock_page" will be NULL.
> 
> Cc: Nick Piggin <npiggin@kernel.dk>

Looks good, 

Acked-by: Nick Piggin <npiggin@kernel.dk>
