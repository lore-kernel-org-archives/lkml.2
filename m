Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab2BXTkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:40:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63211 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab2BXTkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:40:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of arnaldo.melo@gmail.com designates 10.236.154.137 as permitted sender) smtp.mail=arnaldo.melo@gmail.com; dkim=pass header.i=arnaldo.melo@gmail.com
Date: Fri, 24 Feb 2012 17:39:58 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf tools: ensure comm properly terminated If threads
 in a multi-threaded process have names shorter than the main thread the comm
 for the named threads is not properly terminated.
Message-ID: <20120224193958.GE27882@infradead.org>
References: <1330111898-68071-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330111898-68071-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 24, 2012 at 12:31:38PM -0700, David Ahern escreveu:
> e.g., for the process 'namedthreads' where each thread is named noploop%d
> where %d is the thread number:
> 
> Before:
>     perf script -f comm,tid,ip,sym,dso
>     noploop:4ads 21616  400a49 noploop (/tmp/namedthreads)
> The 'ads' in the thread comm bleeds over from the process name.
> 
> After:
>     perf script -f comm,tid,ip,sym,dso
>        noploop:4 21616  400a49 noploop (/tmp/namedthreads)

Thanks, applied to perf/urgent.

- Arnaldo
