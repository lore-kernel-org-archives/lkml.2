Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab1BARgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:36:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52783 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab1BARgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:36:05 -0500
Subject: Re: [PATCH 1/2] perf tools: Remove verbose build messages for the
 python binding
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <1296581395-30663-2-git-send-email-acme@infradead.org>
References: <1296581395-30663-1-git-send-email-acme@infradead.org>
	 <1296581395-30663-2-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 18:36:59 +0100
Message-ID: <1296581819.26581.247.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 15:29 -0200, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Also now it builds it in a well known location:
> 
> [acme@felicio linux]$ rm -rf ../build/perf/
> [acme@felicio linux]$ mkdir ../build/perf
> [acme@felicio linux]$ make -j2 O=~acme/git/build/perf -C tools/perf/
> <SNIP>
> [acme@felicio linux]$ ls -la ../build/perf/python/
> total 152
> -rwxrwxr-x 1 acme acme 147957 Feb  1 14:56 perf.so
> drwxrwxr-x 3 acme acme     17 Feb  1 14:56 temp
> [acme@felicio linux]$
> 
> [root@felicio ~]# strip ~acme/git/build/perf/python/perf.so
> [root@felicio ~]# ls -la ~acme/git/build/perf/python/perf.so
> -rwxrwxr-x 1 acme acme 46264 Feb  1 14:58 /home/acme/git/build/perf/python/perf.so
> 
> [root@felicio ~]# export PYTHONPATH=~acme/git/build/perf/python/
> [root@felicio ~]# ~acme/git/linux/tools/perf/python/twatch.py
> cpu:  0, pid: 7751, tid: 7751 { type: exit, pid: 7751, ppid: 7751, tid: 7751, ptid: 7751, time: 54562393512356}
> cpu:  0, pid: 13700, tid: 13700 { type: fork, pid: 7756, ppid: 13700, tid: 7756, ptid: 13700, time: 54562393746739}
> cpu:  1, pid: 7756, tid: 7756 { type: fork, pid: 7757, ppid: 7756, tid: 7757, ptid: 7756, time: 54562394246152}
> cpu:  1, pid: 7757, tid: 7757 { type: comm, pid: 7757, tid: 7757, comm: awk }
> cpu:  1, pid: 7757, tid: 7757 { type: exit, pid: 7757, ppid: 7757, tid: 7757, ptid: 7757, time: 54562395456813}

This won't fix this, right?

running build_ext
error: invalid Python installation: unable to open /usr/lib64/python2.6/config/Makefile (No such file or directory)
make: *** [pyrf] Error 1


