Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab1E0IgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:36:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43711 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab1E0IgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:36:17 -0400
Date: Fri, 27 May 2011 10:35:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, eranian@google.com, tzanussi@gmail.com,
        penberg@cs.helsinki.fi, torvalds@linux-foundation.org, efault@gmx.de,
        peterz@infradead.org, davej@redhat.com, davem@davemloft.net,
        fweisbec@gmail.com, kees.cook@canonical.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf symbols: Handle
 /proc/sys/kernel/kptr_restrict
Message-ID: <20110527083554.GA21386@elte.hu>
References: <tip-mt512joaxxbhhp1odop04yit@git.kernel.org>
 <20110526193946.GA6363@elte.hu>
 <20110526212805.GB30593@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526212805.GB30593@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Thu, May 26, 2011 at 09:39:46PM +0200, Ingo Molnar escreveu:
> > Secondly, even though i have the proper 'vmlinux' in cwd, i get half 
> > a page long warnings on perf record warning me about the vmlinux:
> > 
> >   WARNING: Kernel address maps (/proc/{kallsyms,modules}) are restricted, check /proc/sys/kernel/kptr_restrict.
> > 
> >   Samples in kernel functions may not be resolved if a suitable 
> >   vmlinux file is not found in the buildid cache or in the vmlinux 
> >   path.
> > 
> >   ...
> > 
> > But a vmlinux file *is* in the cwd.
> 
> Well, there was no assumption that 'perf report' would run on the same
> directory as 'perf record', the user may have moved to a different
> directory or transferred the perf.data file to a different machine.
> 
> Also it would have to check that the vmlinux on the path is suitable
> (that build-id matches), currently it does that just at 'perf report'
> time, that is when it will need to use it. At record time we just
> collect the build-ids.
> 
> With that in mind, how do you think it should be phrased?

I think the biggest problem is that it is yelling at us even when i'm 
root - and root can access all the pointer values just fine:

 # id
 uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023

 # perf report --stdio
 No kallsyms or vmlinux with build-id 122214021a666675f6e5ff97d70a85ce7139c0e7 was found
 [kernel.kallsyms] with build id 122214021a666675f6e5ff97d70a85ce7139c0e7 not found, continuing without s
 Kernel address maps (/proc/{kallsyms,modules}) were restricted, check /proc/sys/kernel/kptr_restrict bef

 # tail -1 /proc/kallsyms 
 ffffffffff600d00 D __vvar_vsyscall_gtod_data

Thanks,

	Ingo
