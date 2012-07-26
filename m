Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab2GZRm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:42:58 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59968 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094Ab2GZRm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:42:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120725182747.GB14996@krava.brq.redhat.com>
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
	<1342959280-5361-3-git-send-email-jolsa@redhat.com>
	<CABPqkBQONxpNAm=rE9JpQ8Pjdfzf6dc707UZWhSzM+E0AAXE-w@mail.gmail.com>
	<20120725182747.GB14996@krava.brq.redhat.com>
Date: Thu, 26 Jul 2012 19:42:55 +0200
Message-ID: <CABPqkBQz88k4Srw+QLu-7OWC=xGtg1DDNFMiRfN10vRsZHVZ0w@mail.gmail.com>
Subject: Re: [PATCH 02/17] perf: Add ability to attach user level registers
 dump to sample
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 8:27 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Jul 25, 2012 at 07:39:18PM +0200, Stephane Eranian wrote:
>> On Sun, Jul 22, 2012 at 2:14 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>
> SNIP
>
>> > +       if (sample_type & PERF_SAMPLE_REGS_USER) {
>> > +               u64 avail = (data->regs_user != NULL);
>> > +
>> > +               /*
>> > +                * If there are no regs to dump, notice it through
>> > +                * first u64 being zero.
>> > +                */
>> > +               perf_output_put(handle, avail);
>> > +
>> The only role of avail is to report whether or not you've captured actual
>> registers. Could it be used to report the sampled process ABI (32 vs. 64)
>> instead? Something like:
>>       PERF_SAMPLE_REGS_ABI_NONE -> no regs captured (emulate your
>> current behavior)
>>       PERF_SAMPLE_REGS_ABI_32 -> 32 bit ABI regs captured
>>       PERF_SAMPLE_REGS_ABI_64 -> 64 bit ABI regs captured
>>
>> That could help the tools interpret the register values.
>
> Yes, I think that could help once we start dealing with compat tasks.
>
You don't control whether or not you capture compat tasks. So
you have to deal with those right now.

> The current userspace code stays untouched, because it checks for
> 'avail != 0', which stays even with your change.
>
> I think this could be sent later with all other fixes I'm already
> working on. But I can work/send it preferentially before whole patchset
> is taken if you like.
>
Well, why not do it now. You'd have to rename the available field
into something more sensible. Also need to prepare it for future
extension if they ever become necessary.
