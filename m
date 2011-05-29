Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1E2ONJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 10:13:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:54826 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1E2ONI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 10:13:08 -0400
Date: Sun, 29 May 2011 11:12:56 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/5] perf/urgent fixes
Message-ID: <20110529141256.GA12777@ghostprotocols.net>
References: <1306532736-3790-1-git-send-email-acme@infradead.org>
 <20110528094150.GA12059@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110528094150.GA12059@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, May 28, 2011 at 11:41:50AM +0200, Ingo Molnar escreveu:
> The various variations of kptr_restrict now work fine AFAICS - will 
> send the fixes to Linus today.
> 
> One (very) small issue i noticed, if the user only samples user-space 
> events then i still get the warning:
> 
>  aldebaran:~> perf record -e cycles:upp sleep 1
>  WARNING: Kernel address maps (/proc/{kallsyms,modules}) are restricted,
> 
> although perf does not record any kernel samples so kptr_restrict is 
> irrelevant in this case.

I'll have that fixed too, oversight. We really should avoid confusing
messages, and this one, as you mention, seems just noise as I still have
to look again how vsyscall symbols get resolved, IIRC they need a kernel
symtab, but then, if that is the case, the message should be changed
accordingly.

- Arnaldo
