Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab2ECKZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 06:25:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab2ECKZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 06:25:38 -0400
Date: Thu, 3 May 2012 12:25:03 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, rostedt@goodmis.org,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com,
        Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 02/16] perf: Unified API to record selective sets of arch
 registers
Message-ID: <20120503102503.GA1671@m.brq.redhat.com>
References: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
 <1334661441-4420-3-git-send-email-jolsa@redhat.com>
 <CABPqkBRqG5WhWYY5viVW3j89WUrpmkk1j7VA=oUhY_TGXg=14g@mail.gmail.com>
 <20120423103350.GB1720@m.brq.redhat.com>
 <20120426152840.GC1659@m.brq.redhat.com>
 <CABPqkBSC02vBxAPLrS6j4bVFGme3ibKH=VOkT0yHVCP=pJMnYA@mail.gmail.com>
 <20120502122618.GE1548@m.brq.redhat.com>
 <CABPqkBTFfHtqd0Zk7go4w6aC26vdjHirOyWRqXFct_5Q-ndx5A@mail.gmail.com>
 <20120502125830.GF1548@m.brq.redhat.com>
 <CABPqkBSkdo8spm17qjBANJ5oYnU0Ri1wegxx4i0fQVvz976e+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSkdo8spm17qjBANJ5oYnU0Ri1wegxx4i0fQVvz976e+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 04:46:33PM +0200, Stephane Eranian wrote:
> On Wed, May 2, 2012 at 2:58 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > SNIP
> >
> >> >
> >> > I just sent v3, with changed design to be more generic, please check
> >> >
> >> > anyway, currently there's no way to mix 32 and 64 bit registers in sample.
> >> >
> >> > As I mentioned above, once running compat task, 64 bit registers
> >> > are stored anyway. Given that all 32 bit registers have 64 equiv.
> >> > you can ask to store RAX|RBX|R15.
> >> >
> >> Well, R8-R15 do not exist in 32-bit mode. So I wonder what is saved
> >> on the stack for those, probably nothing. And in that case, how do you
> >> handle the case where the user asked for R15 but it is not available and
> >> you know that only on PMU interrupt.
> >
> > right, R8-R15 do not exist in 32 bit mode, meaning that the 32 bit task
> > do not use them... but when you enter 64 bit kernel from 32 bit compat
> > task, still 64bits registers are saved.. as for native 64 process,
> 
> I am confused by your term '64-bit registers' here. I assume you
> mean registers are saved as 64-bit integers. But that does not means
> that the full set of 64-bit registers (incl. R8-R15) is saved. Unless
same set as for 64 bit tasks.. it's not allways full as I described
in previous email

> you're telling
> me that whatever values are in those 64-bit ABI only registers are thus saved
> on the stack.
yep, thats what I see in arch/x86/ia32/ia32entry.S

jirka
