Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab1EZV3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 17:29:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab1EZV3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 17:29:09 -0400
Date: Thu, 26 May 2011 18:28:05 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, eranian@google.com, tzanussi@gmail.com,
        penberg@cs.helsinki.fi, torvalds@linux-foundation.org, efault@gmx.de,
        peterz@infradead.org, davej@redhat.com, davem@davemloft.net,
        fweisbec@gmail.com, kees.cook@canonical.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf symbols: Handle
	/proc/sys/kernel/kptr_restrict
Message-ID: <20110526212805.GB30593@ghostprotocols.net>
References: <tip-mt512joaxxbhhp1odop04yit@git.kernel.org> <20110526193946.GA6363@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526193946.GA6363@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 26, 2011 at 09:39:46PM +0200, Ingo Molnar escreveu:
> Secondly, even though i have the proper 'vmlinux' in cwd, i get half 
> a page long warnings on perf record warning me about the vmlinux:
> 
>   WARNING: Kernel address maps (/proc/{kallsyms,modules}) are restricted, check /proc/sys/kernel/kptr_restrict.
> 
>   Samples in kernel functions may not be resolved if a suitable 
>   vmlinux file is not found in the buildid cache or in the vmlinux 
>   path.
> 
>   ...
> 
> But a vmlinux file *is* in the cwd.

Well, there was no assumption that 'perf report' would run on the same
directory as 'perf record', the user may have moved to a different
directory or transferred the perf.data file to a different machine.

Also it would have to check that the vmlinux on the path is suitable
(that build-id matches), currently it does that just at 'perf report'
time, that is when it will need to use it. At record time we just
collect the build-ids.

With that in mind, how do you think it should be phrased?

- Arnaldo
