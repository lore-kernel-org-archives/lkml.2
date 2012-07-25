Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab2GYS2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:28:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab2GYS2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:28:37 -0400
Date: Wed, 25 Jul 2012 20:27:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 02/17] perf: Add ability to attach user level registers
 dump to sample
Message-ID: <20120725182747.GB14996@krava.brq.redhat.com>
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
 <1342959280-5361-3-git-send-email-jolsa@redhat.com>
 <CABPqkBQONxpNAm=rE9JpQ8Pjdfzf6dc707UZWhSzM+E0AAXE-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQONxpNAm=rE9JpQ8Pjdfzf6dc707UZWhSzM+E0AAXE-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 07:39:18PM +0200, Stephane Eranian wrote:
> On Sun, Jul 22, 2012 at 2:14 PM, Jiri Olsa <jolsa@redhat.com> wrote:

SNIP

> > +       if (sample_type & PERF_SAMPLE_REGS_USER) {
> > +               u64 avail = (data->regs_user != NULL);
> > +
> > +               /*
> > +                * If there are no regs to dump, notice it through
> > +                * first u64 being zero.
> > +                */
> > +               perf_output_put(handle, avail);
> > +
> The only role of avail is to report whether or not you've captured actual
> registers. Could it be used to report the sampled process ABI (32 vs. 64)
> instead? Something like:
>       PERF_SAMPLE_REGS_ABI_NONE -> no regs captured (emulate your
> current behavior)
>       PERF_SAMPLE_REGS_ABI_32 -> 32 bit ABI regs captured
>       PERF_SAMPLE_REGS_ABI_64 -> 64 bit ABI regs captured
> 
> That could help the tools interpret the register values.

Yes, I think that could help once we start dealing with compat tasks.

The current userspace code stays untouched, because it checks for
'avail != 0', which stays even with your change.

I think this could be sent later with all other fixes I'm already
working on. But I can work/send it preferentially before whole patchset
is taken if you like.

thanks,
jirka
