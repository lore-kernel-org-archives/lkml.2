Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479Ab0HLR41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 13:56:27 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65124 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab0HLR41 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 13:56:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VO7zTywSnjO/qDYLmnhnk1ndxiTbJ0ww7tIIWDmSqngyy4gSfTIUlPWpSQNnpQ4drt
         EfAfAdmgayXLeOZI8q0bDSbfn8b8Fi26dMSP0NmWo44u1CDpW8ij92oJi78RslJ2mimC
         lRhxRroUt3MHVg31vFRkjCbGDxn1U3yfEQay0=
MIME-Version: 1.0
In-Reply-To: <AANLkTinSpaSMusUkBZG3-b_hNf5ADfOw2jHE=yE4ysZ_@mail.gmail.com>
References: <AANLkTinSpaSMusUkBZG3-b_hNf5ADfOw2jHE=yE4ysZ_@mail.gmail.com>
Date: Thu, 12 Aug 2010 12:56:24 -0500
Message-ID: <AANLkTinLX0DitUKn-k=-ucmrf3j5TYN_yK1NZ7hY8ok8@mail.gmail.com>
Subject: Re: [BUG] perf: trace -s script is broken
From: Tom Zanussi <tzanussi@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 12, 2010 at 4:39 AM, Stephane Eranian <eranian@google.com> wrote:
> Hi,
>
> I am trying to understand how you're supposed to use perf trace with a
> script using tip-x86.
> I am running into several problems.
>
> I did:
> $ make prefix=/usr
> $ sudo make install prefix=/usr
>
> $ sudo perf record -c 1 -e raw_syscalls:sys_enter -a -- sleep 1
> $ sudo perf trace -s sctop.py
> Can't open python script "sctop.py": No such file or directory
>
> I looked into this a bit more, and sure enough, it seems perf is only looking
> in the current subdir to find sctop.py. However if you do:
> $ perf trace -l
> List of available trace scripts:
>  failed-syscalls [comm]               system-wide failed syscalls
>  rw-by-file <comm>                    r/w activity for a program, by file
>  rw-by-pid                            system-wide r/w activity
>  rwtop [interval]                     system-wide r/w top
>  wakeup-latency                       system-wide min/max/avg wakeup latency
>  workqueue-stats                      workqueue stats (ins/exe/create/destroy)
>  failed-syscalls-by-pid [comm]        system-wide failed syscalls, by pid
>  sctop [comm] [interval]              syscall top
>  syscall-counts-by-pid [comm]         system-wide syscall counts, by pid
>  syscall-counts [comm]                system-wide syscall counts
>
> The listing requires trace to look at /usr/libexec/perf-core/scripts/*
>
> I think in builtin-trace.c, you need to add the path prefix, perf_path_exec()
> to the script_name for this to work correctly. Or am I missing something here?
>
> Similarly, all the -report scripts installed via make install, still
> have the ~/libexec
> prefix hardcoded into them. I believe those should be relative to the
> install prefix
> instead.
>

Yeah, I had previously submitted a patch to fix this, but that patch
introduced another bug.

I'll send an updated v2 patch shortly that should fix both problems...

Thanks,

Tom
