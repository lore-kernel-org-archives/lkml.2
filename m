Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab0JNLqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 07:46:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63440 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab0JNLqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 07:46:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Pl11QzbHVGfe8SPcweLdb6sG+1zay0Ho9Yr3kfKrHBiHt0aY/eqAbJSuaJ+6+ZNCTR
         gZ4db/2zJPtrqjqCsxd6Ltnsbkh4LJVajM3/blmJaaI3OUXiLOdq/N8Iev+9VIuEBoTc
         HQJ/PKCol2bIcsZqRixpX5ZidZ0SUEBpbXDpw=
Date: Thu, 14 Oct 2010 13:20:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH 2/9] perf: Add ability to dump user regs
Message-ID: <20101014112000.GA5336@nowhere>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com> <1286946421-32202-3-git-send-regression-fweisbec@gmail.com> <1286954453.29097.58.camel@twins> <AANLkTinhGrdGyLaOGtXPktQM2uQ_0M9XQ1GjtBAYf+LY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinhGrdGyLaOGtXPktQM2uQ_0M9XQ1GjtBAYf+LY@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 01:06:30PM +0200, Stephane Eranian wrote:
> Hi,
> 
> 
> 
> On Wed, Oct 13, 2010 at 9:20 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2010-10-13 at 07:06 +0200, Frederic Weisbecker wrote:
> >> Add new PERF_SAMPLE_UREGS to perf sample type. This will dump the
> >> user space context as it was before the user entered the kernel for
> >> whatever reason.
> >>
> >> This is going to be useful to bring Dwarf CFI based stack unwinding
> >> on top of samples.
> >
> > This doesn't address any of the issues that were raised previously.
> >
> > There's a reason we don't have PERF_SAMPLE_*REGS like things.
> >
> We definitively need to find a solution to this problem. It is important
> to export this kind of information to users when using PEBS, for instance



Would you need to export only a part of the regs for cases like PEBS?



> 
> What is exported depends on what is monitored and not just the ABI
> of the kernel. On a 64-bit kernel, you may capture samples from
> i386 or x86_64. Somehow the record needs to be self describing.
> 
> What about something like:
> struct  {
>       int type; /* 32-bit, 64-bit */
>       int nr;    /* number of regs */
>       struct {
>           int reg_name; /* taken from an enum with all possible regs */
>           u64 reg_value;
>       } [0]
> };



Yeah but in this case we can probably avoid to embed all the regnames
in every dumps. This can be retrieved from what we asked in the attrs,
which could be a u64 bitmap that tells which regs we want? (that only
if we want a per reg granularity).

