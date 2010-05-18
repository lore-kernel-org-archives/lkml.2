Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab0EROEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:04:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757472Ab0EROET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:04:19 -0400
Date: Tue, 18 May 2010 11:03:45 -0300
From: "acme@redhat.com" <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mhiramat@redhat.com" <mhiramat@redhat.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:perf/core] perf probe: Don't compile CFI related code if
	elfutils is old
Message-ID: <20100518140345.GH29052@ghostprotocols.net>
References: <20100510171207.26029.97604.stgit@localhost6.localdomain6> <tip-7752f1b096e13991f20b59fd11ba73da3809d93c@git.kernel.org> <20100518093535.GF21799@erda.amd.com> <AANLkTilWR9fEWBOZLyvFcU6DR6i9aswpSRzFnlIiSoNm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTilWR9fEWBOZLyvFcU6DR6i9aswpSRzFnlIiSoNm@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 18, 2010 at 11:39:58AM +0200, Stephane Eranian escreveu:
> On Tue, May 18, 2010 at 11:35 AM, Robert Richter <robert.richter@amd.com> wrote:
> > On 17.05.10 21:57:38, tip-bot for Masami Hiramatsu wrote:
> >> Commit-ID:  7752f1b096e13991f20b59fd11ba73da3809d93c
> >> Gitweb:     http://git.kernel.org/tip/7752f1b096e13991f20b59fd11ba73da3809d93c
> >> Author:     Masami Hiramatsu <mhiramat@redhat.com>
> >> AuthorDate: Mon, 10 May 2010 13:12:07 -0400
> >> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> >> CommitDate: Mon, 17 May 2010 22:13:51 -0300

> >> perf probe: Don't compile CFI related code if elfutils is old
> >> Check elfutils version, and if it is old don't compile CFI analysis code. This
> >> allows to compile perf with old elfutils.

> >> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> >> Tested-by: Stephane Eranian <eranian@google.com>
> >> Reported-by: Robert Richter <robert.richter@amd.com>
> >> Cc: Ingo Molnar <mingo@elte.hu>
> >> LKML-Reference: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
> >> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

> > I think this patch is not needed as we came up with an alternative
> > solution with commit:

> >  6b3c4ef perf probe: Check older elfutils and set NO_DWARF

Yeah, that was confusing, my understanding was that 6b3c4ef superseeded
7752f1b, but it was needed in addition to it, as can be seen by
Stephane's report.

6b3c4ef worked for you because it used the heavy hammer, by not noticing
the _ELFUTILS_PREREQ macro it decided that the elfutils version
installed was way too old, so disable everything related to it, i.e.
perf probe will work just with /proc/kallsyms. I.e. your version of
elfutils  was <= 0.138, that is when the PREREQ macro was introduced.

But Stephanes is > 0.138 _but_ < 0.142, that is when Dwarf_CFI appeared,
so he can use the PREREQ macro to build only removing the code that
depends on Dwarf_CFI being available.

> But I am compiling tip, so this patch is in and I still got the problem.
> It is because the test program does not check for Dwarf_CFI so it
> assumes you have the right version of libdw.
> 
> If I understand Masami's patch, you can still compile dwarf support
> in despite the lack of Dwarf_CFI.

Right.

- Arnaldo
