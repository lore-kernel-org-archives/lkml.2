Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab2F0PNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:13:47 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52120 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab2F0PNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:13:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120627151059.GG20638@somewhere.redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
	<1340120894-9465-4-git-send-email-jolsa@redhat.com>
	<20120627151059.GG20638@somewhere.redhat.com>
Date: Wed, 27 Jun 2012 17:13:44 +0200
Message-ID: <CABPqkBTdL7rt4YF1SYdo4N7BaK3TOvXJqfs3Te2Asmm_-jA_Ag@mail.gmail.com>
Subject: Re: [PATCH 03/23] perf: Add ability to attach user level registers
 dump to sample
From: Stephane Eranian <eranian@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 5:11 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Tue, Jun 19, 2012 at 05:47:54PM +0200, Jiri Olsa wrote:
>> @@ -4061,6 +4105,19 @@ void perf_prepare_sample(struct perf_event_header *header,
>>               }
>>               header->size += size;
>>       }
>> +
>> +     if (sample_type & PERF_SAMPLE_REGS_USER) {
>> +             /* regs dump available bool */
>> +             int size = sizeof(u64);
>> +
>> +             data->regs_user = perf_sample_regs_user(regs);
>> +             if (data->regs_user) {
>> +                     u64 mask = event->attr.sample_regs_user;
>> +                     size += hweight64(mask) * sizeof(u64);
>> +             }
>> +
>> +             header->size += size;
>
> We'll need to remove the 64 bits registers for compat tasks but other than
> that, it looks ok.
You cannot do this. You cannot remove register values from under the hood.
The only way the user has to parse the sample is the sample_regs_users bitmask.
You have to return 0 for those unexisting regs for compat tasks.
