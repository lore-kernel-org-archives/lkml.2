Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2FMNvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:51:15 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39367 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2FMNvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:51:12 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBRnMW=Zmi+DycUPMcYS9cgs8doKZqSR37e1gU6wQnT+nw@mail.gmail.com>
References: <1339420814-7379-1-git-send-email-jolsa@redhat.com>
	<1339420814-7379-3-git-send-email-jolsa@redhat.com>
	<CABPqkBRsBegm6gv6agHcGb0Hh1EWCV5gjVnbbwPHh-eOfROCuw@mail.gmail.com>
	<20120613131240.GB2538@m.brq.redhat.com>
	<CABPqkBRdVMzocJu_SJbU81wg6Ef=KgbXw-18tb+bZEon79fVDA@mail.gmail.com>
	<1339594802.8980.44.camel@twins>
	<CABPqkBRnMW=Zmi+DycUPMcYS9cgs8doKZqSR37e1gU6wQnT+nw@mail.gmail.com>
Date: Wed, 13 Jun 2012 15:51:11 +0200
Message-ID: <CABPqkBTVBG92pUu-H+CSO4T1HojQsun7ngZ8Z8PJUFt-MwXkRg@mail.gmail.com>
Subject: Re: [PATCH 02/19] perf: Add ability to attach user level registers
 dump to sample
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 3:41 PM, Stephane Eranian <eranian@google.com> wrote:
> On Wed, Jun 13, 2012 at 3:40 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> On Wed, 2012-06-13 at 15:18 +0200, Stephane Eranian wrote:
>>>
>>> If you look carefully at perf_output_sample(), you will notice that data is
>>> written in the exact order of the enum perf_event_sample_format.
>>
>> Not so actually.. CALLCHAIN is out of order. Not sure why we did that
>> though.
>>
>>
>> But it should match the comment near PERF_RECORD_SAMPLE.
>
> Ok, yes that one. It would have been much nicer to follow the enum
> order.
In that case, the comment needs to be update to show the sample_user_regs[]
in the right order.

         *      { u32                   size;
         *        char                  data[size];}&& PERF_SAMPLE_RAW
         *
         *      { u64 from, to, flags } lbr[nr];} && PERF_SAMPLE_BRANCH_STACK
         *      { u64 size; u64 regs[size];} && PERF_SAMPLE_USER_REGS

Same thing for the user stack.
