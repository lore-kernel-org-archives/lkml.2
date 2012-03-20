Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab2CTWTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:19:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab2CTWTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:19:09 -0400
Date: Tue, 20 Mar 2012 19:18:45 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        mingo@elte.hu, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] perf, tool: Add new event group management
Message-ID: <20120320221845.GB21163@infradead.org>
References: <1332267341-26338-1-git-send-email-jolsa@redhat.com>
 <1332267341-26338-4-git-send-email-jolsa@redhat.com>
 <1332269081.18960.444.camel@twins>
 <20120320204625.GA17142@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120320204625.GA17142@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 20, 2012 at 09:46:25PM +0100, Ingo Molnar escreveu:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Now the disadvantage is that {} needs quotes on bash, [...]
> 
> Not on my version of Bash:
> 
>  earth5:~> perf stat {}
>  {}: No such file or directory
>  Terminated
>  earth5:~> perf stat true {}
> 
>   Performance counter stats for 'true {}':
> 
> it's passed in literally, AFAICS.

I like it, but...

[acme@felicio ~]$ perf stat -e {cycles,cache-misses} ls
cache-misses: No such file or directory
Terminated
[acme@felicio ~]$ perf stat -e \{cycles,cache-misses\} ls
invalid or unsupported event: '{cycles,cache-misses}'
Run 'perf list' for a list of valid events

but:

[acme@felicio ~]$ perf stat -e [cycles,instructions] ls
perf stat -e [cycles,instructions] ls
invalid or unsupported event: '[cycles,instructions]'
Run 'perf list' for a list of valid events

[acme@felicio ~]$ perf stat -e [cycles,cache-misses]:u ls
invalid or unsupported event: '[cycles,cache-misses]:u'
Run 'perf list' for a list of valid events

And:

[acme@felicio ~]$ perf stat -e (cycles,cache-misses) ls
bash: syntax error near unexpected token `('
[acme@felicio ~]$

- Arnaldo
