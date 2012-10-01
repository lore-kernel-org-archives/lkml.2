Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab2JAHWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 03:22:00 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37180 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab2JAHV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 03:21:59 -0400
Date: Mon, 1 Oct 2012 09:21:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v2 3/4] perf annotate: configure objdump path at compile
 time
Message-ID: <20121001072154.GA17143@gmail.com>
References: <1348428446-28245-1-git-send-email-irina.tirdea@gmail.com>
 <1348428446-28245-4-git-send-email-irina.tirdea@gmail.com>
 <1348578539.1877.40.camel@leonhard>
 <CANg8OW+u=dsi=5Y04ka0D=VLKEUELAo1L3mkWhs5mOqTS4c1jA@mail.gmail.com>
 <87d318w7u9.fsf@sejong.aot.lge.com>
 <CANg8OWLR64RQYMwi=vx78tWBfcML4CPrerXV3nE+ngYkJ3Ru=A@mail.gmail.com>
 <87haqjvc6f.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87haqjvc6f.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> On Thu, 27 Sep 2012 14:25:10 +0300, Irina Tirdea wrote:
> >>> The perf built to run on the host needs to use arm-eabi-objdump from
> >>> the toolchain so that it can analyse data recorded on Android. This
> >>> patch is targeting this scenario, not the previous one. In this case,
> >>> the CROSS_COMPILE option would be different than arm-eabi- so using
> >>> $(CROSS_COMPILE)objdump would be wrong. objdump should be overridden
> >>> when running make since there is no connection between the toolchain
> >>> used here and the path for objdump. I am always overriding objdump
> >>> when calling make, so I did not catch this.
> >>>
> >>> I think that I should change DEFAULT_OBJDUMP_PATH=objdump in the
> >>> Makefile to handle the first scenario. I'll also explain this in the
> >>> commit message so that it is more clear and make the same change for
> >>> the addr2line patch.
> >>>
> >>> What do you think?
> >>
> >> I think the right thing to do is finding a correct objdump at runtime in
> >> some way.  Why do you want to make it compile-time configurable?
> >>
> >
> > The correct objdump path can be detected at runtime by setting the
> > toolchain path. But since the name is arm-eabi-objdump and not
> > objdump, it does not know to use it instead.
> >
> > The only way (I can think of) to change objdump at runtime would be to
> > use the --objdump option for perf annotate (and provide a similar
> > option for addr2line). The problem with this approach is that the user
> > has to be aware that perf annotate uses the objdump tool and that he
> > has to use the cross-compiler version instead. Since the user will
> > have perf compiled for host as part of his Android tree, he will
> > expect it to work without these further changes from his part. The
> > path for objdump can be set in the Android Makefile at compile time so
> > that the user doesn't need to be aware of it.
> 
> What I'm thinking is that perf can try to find cross-built 
> binutils when it detects perf.data file is came from other 
> machine/architecture. Fortunately perf_session_env was added 
> recently and it has the arch information from the file so we 
> can use it to find the path.
> 
> Following patch is a proof-of-concept patch and only build 
> tested. What do you think?  Could you play with it for some 
> time? :)

This is a pretty clever idea - much better than hard-coding 
architecture details at build time.

Thanks,

	Ingo
