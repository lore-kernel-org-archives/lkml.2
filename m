Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab2A3UJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:09:20 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49109 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753179Ab2A3UJT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:09:19 -0500
MIME-Version: 1.0
In-Reply-To: <20120130200432.GC5797@infradead.org>
References: <20120113144731.GA5458@quad>
	<20120113165315.GA24387@infradead.org>
	<CABPqkBTe1uqiLm02fijYE2bwF=rWWu=V0mjZQbEzW0TUKa4-+Q@mail.gmail.com>
	<CABPqkBS50jYOHepmAqOzGYY8m+4SCJQuhrMV2yLXRYfdFpE70g@mail.gmail.com>
	<20120130190008.GA5797@infradead.org>
	<CABPqkBSzgc7WSbuS4L1gtCf+3u_q3fx002byArsMjKSxd5zw-g@mail.gmail.com>
	<20120130200432.GC5797@infradead.org>
Date: Mon, 30 Jan 2012 21:09:17 +0100
Message-ID: <CABPqkBQu=82igQV2O_UmJsuDOHh8_VyRQCUGmrGqTBvnEdyN+Q@mail.gmail.com>
Subject: Re: [PATCH] perf: fix broken perf inject -b
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        robert.richter@amd.com
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 9:04 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Mon, Jan 30, 2012 at 08:53:26PM +0100, Stephane Eranian escreveu:
>> On Mon, Jan 30, 2012 at 8:00 PM, Arnaldo Carvalho de Melo
>> <acme@redhat.com> wrote:
>> >
>> > Em Mon, Jan 16, 2012 at 07:53:28PM +0100, Stephane Eranian escreveu:
>> > > On Fri, Jan 13, 2012 at 5:54 PM, Stephane Eranian <eranian@google.com> wrote:
>> > > > On Fri, Jan 13, 2012 at 5:53 PM, Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
>> > > >> Em Fri, Jan 13, 2012 at 03:47:31PM +0100, Stephane Eranian escreveu:
>> > > >>> perf inject -b was broken. It would not inject any build_ids
>> > > >>> into the stream. Furthermore, it would strip samples from the
>> > > >>> stream.
>> > <SNIP>
>> > > >>> @@ -173,6 +178,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
>> > > >>>               goto repipe;
>> > > >>>       }
>> > > >>> +     machine->pid = event->ip.pid;
>> >
>> > > I noticed that this statement conflicts with perf buildid-list (which
>> > > I am also fixing for pipe mode).
>> >
>> > > I don't quite understand why, though.
>> >
>> > Have you reached any conclusion about this problem? I haven't looked at
>> > it in detail, could you please elaborate more?
>> >
>>
>> I ended up removing it. But I am not sure this is correct.
>> Is the pid used in any way when processing buildids?
>
> I can't think of any.
>
> The same DSO could conceivably be present in the virtual machine, the
> host, and in the workstation used for perf report.  We just use the
> build-id in the perf.data file to find the right symtab.
>
Right, so I don't know why it's there...
