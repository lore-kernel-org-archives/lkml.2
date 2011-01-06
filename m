Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab1AFSaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:30:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:47131 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab1AFSaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:30:17 -0500
Date: Thu, 6 Jan 2011 16:30:12 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Han Pingtian <phan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix buffer overflow error caused by specifying
	all tracepoints with -e option
Message-ID: <20110106183012.GD5315@ghostprotocols.net>
References: <20110106093922.GB6713@hpt.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106093922.GB6713@hpt.nay.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 06, 2011 at 05:39:22PM +0800, Han Pingtian escreveu:
> I found when specifying all tracepoints with -e to one of subcommand,
> such as 'top', the program will trigger a buffer overflow error, like
> this:
> 
> *** buffer overflow detected ***: ./perf terminated
> ======= Backtrace: =========
<SNIP>
> ....
> The tracepoints are separated by comma, something like this:
> 
> perf top -e ...,kmem:kmalloc,kmem:kfree,kmem:kmem_cache_free,...
> 
> This comment will fix this problem.
> 
> The root reason of this problem is that store_event_type() is called
> with all the events, and will overflow the 'filename' at
> 
>     strncat(filename, orgname, strlen(orgname));
> 
> The comments will try to call store_event_type() when the event name has
> been found out.

s/comments/patch/g, right? Other than that looks fine, applying.

- Arnaldo
