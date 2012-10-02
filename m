Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab2JBLjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:39:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65038 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2JBLjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:39:24 -0400
MIME-Version: 1.0
In-Reply-To: <1349148496-sup-4820@delenn.ozlabs.ibm.com>
References: <CAOvdn6WPUDqYPpHZip7dxVVXJXT0-zJOUCpgDGb=o+zqq98F0Q@mail.gmail.com>
	<1349148496-sup-4820@delenn.ozlabs.ibm.com>
Date: Tue, 2 Oct 2012 07:39:23 -0400
Message-ID: <CAOvdn6VELd9vPGyptmeBePsNsnQNtgXdgj4bYRfuLyz0cXsD9w@mail.gmail.com>
Subject: Re: linux-next: build failure in dwarf-regs.c
From: Ben Guthro <ben.guthro@gmail.com>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

Once again - apologies for multiple copies of this email. Please reply
to this (plain text) version so it will get through LKML filters.

On Tue, Oct 2, 2012 at 12:24 AM, Ian Munsie <imunsie@au1.ibm.com> wrote:
>
>
> >  CC arch/x86/util/dwarf-regs.o
>
> Is this correct? i.e. Are you building perf for x86?

Yes, x86_64, specifically.

>
> What commandline are you using to build?

cd /data/home/bguthro/dev/orc-newdev.git/linux/build/tools/tools/perf
&& make EXTRAVERSION=-orc

>
> Any exported environment variables that may be relevant?

none that I can think of.

>
> What dev libraries does perf warn is missing (Is libdw-dev among them)?

make[3]: Entering directory
`/data/home/bguthro/dev/orc-newdev.git/linux/build/tools/tools/perf'
Makefile:502: No libunwind found, disabling post unwind support.
Please install libunwind-dev[el] >= 0.99
Makefile:537: No libdw.h found or old libdw.h found or elfutils is
older than 0.138, disables dwarf support. Please install new
elfutils-devel/libdw-dev
Makefile:567: No libaudit.h found, disables 'trace' tool, please
install audit-libs-devel or libaudit-dev
Makefile:580: newt not found, disables TUI support. Please install
newt-devel or libnewt-dev
Makefile:752: No bfd.h/libbfd found, install
binutils-dev[el]/zlib-static to gain symbol demangling

Actually - I hadn't noticed these warnings before.

After installing libdw-dev - the perf build completed successfully.
Perhaps this should be fatal, rather than a warning?

Thanks for your help

Ben
