Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2JCN36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:29:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46885 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab2JCN34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:29:56 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ben Guthro <ben.guthro@gmail.com>, Ian Munsie <imunsie@au1.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf tool: Fix build for NO_DWARF=1 case
References: <CAOvdn6WPUDqYPpHZip7dxVVXJXT0-zJOUCpgDGb=o+zqq98F0Q@mail.gmail.com>
	<1349148496-sup-4820@delenn.ozlabs.ibm.com>
	<CAOvdn6VELd9vPGyptmeBePsNsnQNtgXdgj4bYRfuLyz0cXsD9w@mail.gmail.com>
	<20121002131049.GC6379@krava.brq.redhat.com>
	<20121002214536.GA23354@infradead.org>
	<20121003102928.GA945@krava.brq.redhat.com>
Date: Wed, 03 Oct 2012 22:29:48 +0900
In-Reply-To: <20121003102928.GA945@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 3 Oct 2012 12:29:28 +0200")
Message-ID: <87r4pfwunn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Wed, 3 Oct 2012 12:29:28 +0200, Jiri Olsa wrote:
> On Tue, Oct 02, 2012 at 06:45:36PM -0300, Arnaldo Carvalho de Melo wrote:
>> Em Tue, Oct 02, 2012 at 03:10:49PM +0200, Jiri Olsa escreveu:
>> > On Tue, Oct 02, 2012 at 07:39:23AM -0400, Ben Guthro wrote:
>> > > Actually - I hadn't noticed these warnings before.
>> 
>> > > After installing libdw-dev - the perf build completed successfully.
>> > > Perhaps this should be fatal, rather than a warning?
>> 
>> > attached patch fixies the issue for me. Adding Arnaldo to the loop.
>> 
>> [acme@sandy linux]$ make -j8 -C tools/perf/ LIBUNWIND_DIR=/opt/libunwind O=/home/acme/git/build/perf install
>> cc1: warnings being treated as errors
>> arch/x86/util/dwarf-regs.c:72: error: no previous prototype for ‘get_arch_regstr’
>> make: *** [/home/acme/git/build/perf/arch/x86/util/dwarf-regs.o] Error 1
>> make: *** Waiting for unfinished jobs....
>> make: Leaving directory `/home/git/linux/tools/perf'
>> [acme@sandy linux]$
>> 
>> - Arnaldo
>
> ugh.. forgot the way you build perf ;)
> (also smells like 'automated make test' adept)
>
> Anyway, there's Makefile dependency on PERF_HAVE_DWARF_REGS which
> is defined in arch/x86/Makefile.
>
> So, there's only one right place for '-include arch/$(ARCH)/Makefile'.
> We should think of some other solution, since this seems fragile.
>
> I checked your make and simple make with attached patch
> (only x86_64 arch, and with and without libdw installed).

I posted similar patch few days ago and it slipped into acme/perf/core:

  https://lkml.org/lkml/2012/9/28/194

Can you reproduce it with above change?  Anyway, my apologies, sorry for
the inconvenience.

Thanks,
Namhyung
