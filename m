Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab1AGDQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 22:16:58 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:36458 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab1AGDQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 22:16:56 -0500
Date: Thu, 6 Jan 2011 22:16:49 -0500 (EST)
From: Pingtian Han <phan@redhat.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <691812110.287231.1294370209472.JavaMail.root@zmail04.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110106183012.GD5315@ghostprotocols.net>
Subject: Re: [PATCH] perf: fix buffer overflow error caused by specifying
	all tracepoints with -e option
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My mistake, it should be 'patch' other than 'comments'. Thanks!

----- Original Message -----
From: "Arnaldo Carvalho de Melo" <acme@infradead.org>
To: "Han Pingtian" <phan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Sent: Friday, January 7, 2011 2:30:12 AM
Subject: Re: [PATCH] perf: fix buffer overflow error caused by specifying	all tracepoints with -e option

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
