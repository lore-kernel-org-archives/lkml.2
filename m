Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab2EVPyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:54:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab2EVPyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:54:17 -0400
Date: Tue, 22 May 2012 12:53:56 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] perf, tool: Fix 32 bit values endianity swap for
 sample_id_all header
Message-ID: <20120522155356.GA19962@infradead.org>
References: <1337151548-2396-1-git-send-email-jolsa@redhat.com>
 <1337151548-2396-6-git-send-email-jolsa@redhat.com>
 <4FBB1831.80906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBB1831.80906@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 21, 2012 at 10:38:09PM -0600, David Ahern escreveu:
> On 5/16/12 12:59 AM, Jiri Olsa wrote:
> >We swap the sample_id_all header by u64 pointers. Some members
> >of the header happen to be 32 bit values. We need to handle them
> >separatelly.
> >
> >Note, running following to test perf endianity handling:
> >test 1)
> >   - origin system:
> >     # perf record -a -- sleep 10 (any perf record will do)
> >     # perf report>  report.origin
> >     # perf archive perf.data
> >
> >   - copy the perf.data, report.origin and perf.data.tar.bz2
> >     to a target system and run:
> >     # tar xjvf perf.data.tar.bz2 -C ~/.debug
> >     # perf report>  report.target
> >     # diff -u report.origin report.target
> >
> >   - the diff should produce no output
> >     (besides some white space stuff and possibly different
> >      date/TZ output)
> >
> >test 2)
> >   - origin system:
> >     # perf record -ag -fo /tmp/perf.data -- sleep 1
> >   - mount origin system root to the target system on /mnt/origin
> >   - target system:
> >     # perf script --symfs /mnt/origin -I -i /mnt/origin/tmp/perf.data \
> >      --kallsyms /mnt/origin/proc/kallsyms
> >   - complete perf.data header is displayed
> >
> >Signed-off-by: Jiri Olsa<jolsa@redhat.com>
> 
> Same comment as the last - the commit log could use some words about
> command line arguments you are running and how the output is
> affected. As I mentioned perf-report/script on x86 processes data
> files and parses samples from 32-bit ppc just fine -- including tid,
> pid, comm, filenames, symbols, etc. So is the sample_id_all path run
> and how does this patch change it.

Agreed, Jiri, can you do it? I've applied (2,3)/7, waiting for David's
suggestions to be addressed to pick the rest.

- Arnaldo
 
> Code wise:
> Reviewed-by and Tested-by: David Ahern <dsahern@gmail.com>
