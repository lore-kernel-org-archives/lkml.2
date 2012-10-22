Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab2JVOzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:55:45 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:47685 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab2JVOzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:55:43 -0400
MIME-Version: 1.0
In-Reply-To: <20121022135358.GJ2095@tassilo.jf.intel.com>
References: <1350912052-10066-1-git-send-email-eranian@google.com>
	<1350912052-10066-2-git-send-email-eranian@google.com>
	<20121022135358.GJ2095@tassilo.jf.intel.com>
Date: Mon, 22 Oct 2012 16:55:41 +0200
Message-ID: <CABPqkBTJsZHdvp+Tm3SGJCfJ7eMFaqQR8pd9eoh5KyBo3k6o3Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] perf tools: add event modifier to request
 exclusive PMU access
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 3:53 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On Mon, Oct 22, 2012 at 03:20:51PM +0200, Stephane Eranian wrote:
>> This patch adds the x modifier for events. It allows users to
>> request exclusive PMU access (attr->exclusive):
>>
>> perf stat -e cycles:x ......
>> or
>> perf stat -e cpu/cycles/x ....
>>
>> Exclusive mode is a feature of perf_events which was not yet
>> supported by the perf tool. Some events may require exclusive
>> PMU access (like on Intel SandyBridge).
>
> You probably should add it also to be readable from sysfs
>
Not sure I understand what you mean here.

x is not a HW property, this is a perf_event feature. It should NOT be
exposed in /sys/device/cpu/format/.

But maybe you're talking about a generic event exports in
/sys/device/cpu/events.
But why would I expose prec_dist there. And under what name?


> (like I did with precise in my haswell patchkit)
>
> Then the SNB version of instructions-p can just force this
> without the user having to do anything special.
>
> -Andi
