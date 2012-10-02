Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab2JBEZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 00:25:24 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:43071 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2JBEZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 00:25:23 -0400
Content-Type: text/plain; charset=UTF-8
From: Ian Munsie <imunsie@au1.ibm.com>
To: Ben Guthro <ben@guthro.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: linux-next: build failure in dwarf-regs.c
In-reply-to: <CAOvdn6WPUDqYPpHZip7dxVVXJXT0-zJOUCpgDGb=o+zqq98F0Q@mail.gmail.com>
References: <CAOvdn6WPUDqYPpHZip7dxVVXJXT0-zJOUCpgDGb=o+zqq98F0Q@mail.gmail.com>
Date: Tue, 02 Oct 2012 14:24:59 +1000
Message-Id: <1349148496-sup-4820@delenn.ozlabs.ibm.com>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
x-cbid: 12100204-6102-0000-0000-000002511479
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ben,

Adding some people to CC...

Excerpts from Ben Guthro's message of 2012-10-02 11:02:59 +1000:
> I pulled the latest bits up to 797b9e5ae93270ec27a1f1ed48cd697d01b2269f -
> but am seeing the following build failure with gcc 4.6.3

Building that SHA works for me (on x86, haven't tried PPC yet)...

>  CC arch/x86/util/dwarf-regs.o

Is this correct? i.e. Are you building perf for x86?

What commandline are you using to build?

Any exported environment variables that may be relevant?

What dev libraries does perf warn is missing (Is libdw-dev among them)?

> arch/x86/util/dwarf-regs.c:72:13: error: no previous prototype for
> 'get_arch_regstr' [-Werror=missing-prototypes]

Hmmm... util/include/dwarf-regs.h not included? DWARF_SUPPORT undefined
but still building that file for some reason?

Can't see any obvious way that could happen... You didn't happen to see
an warning along the lines of 'DWARF register mappings not defined for
x86' did you?

> `/data/home/bguthro/dev/orc-newdev.git/linux/build/tools/tools/perf'

I hope the two 'tools' here is just an O= artefact?

> git blame shows that line coming in from the following changeset - though
> April is a long time ago in kernel time

Especially when it's April from two years ago...

> - so this must have come in with some other merge in this 3.7 window

Seems likely, especially as (excerpt from git diff --stat v3.6 797b9e5
-- tools/perf):

tools/perf/arch/x86/Makefile            | 3 +
tools/perf/arch/x86/include/perf_regs.h | 80 +++
tools/perf/Makefile                     | 173 ++++--

I see a few changes in there that may have caused this... Since I can't
reproduce this myself I can't narrow it down, so I'm adding David Ahern,
Namhyung Kim & Jiri Olsa to CC who have touched lines that look like the
might be relevant.

Ben: You should be able to narrow down the cause of the breakage a bit
more with git bisect start 797b9e5 v3.6 -- tools/perf/Makefile

Cheers,
-Ian

