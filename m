Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab0ENMHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 08:07:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47495 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab0ENMHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 08:07:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FBzTZiBzDENGRquXj+sZNz6HlehUEAHk3Mtl/Uq33OwHZOiB0hQj7I4Yz6pQ0cqLEf
         p6vTXjSf+XGckkyCtzpDQZyGhqZEMO91ZdZrvwibwb5eAmcN6YuQwu+HPI+9kqCIx/wK
         tYK1RbtHwjBa4kcoJZheJkoYGD1ucA3b4WHY8=
MIME-Version: 1.0
In-Reply-To: <20100514115655.GA18069@elte.hu>
References: <AANLkTimKHkgWJJOOICzQ4TL3mbL-lvYEocwBSe3XSBVR@mail.gmail.com>
	 <AANLkTiktLXqHhop21ePIXF2kaVQbm3DIHZpLrEQOMA1e@mail.gmail.com>
	 <AANLkTimCjt0R7A23xTrmToTqTcF4ZW4sNWtjMwjVIVqe@mail.gmail.com>
	 <AANLkTinbrhuGqHss_aML3EAccOq792GUZtqzzjQqzG6I@mail.gmail.com>
	 <AANLkTimVmlPfRFu8Wo2KL1pyF6qtTSQriawvrKcsMe9Y@mail.gmail.com>
	 <AANLkTimrHGq1kZwPev7gBZu6Hqxlhe0ZscSKjEinZtcf@mail.gmail.com>
	 <AANLkTik-gIjZu60pFWEhhe8MolQITrtk0wfpvSUCLnrD@mail.gmail.com>
	 <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com>
	 <1273834571.3530.82.camel@minggr.sh.intel.com>
	 <20100514115655.GA18069@elte.hu>
Date: Fri, 14 May 2010 16:07:47 +0400
Message-ID: <AANLkTikz_5oiNw1R_XWtJ7frTkk0NCBhoHEQY59Mfc1N@mail.gmail.com>
Subject: Re: Performance Events hangs with Intel P4 system
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 14, 2010, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Lin Ming <ming.m.lin@intel.com> wrote:
>
>> p4_event_bind::cntr is "unsigned char".
>> But p4_next_cntr has return type of "int".
>> So the explicit conversion is needed to get the correct result.
>
>> @@ -780,7 +780,7 @@ static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign
>>               if (unlikely(escr_idx == -1))
>>                       goto done;
>>
>> -             if (hwc->idx != -1 && !p4_should_swap_ts(hwc->config, cpu)) {
>> +             if (hwc->idx != (unsigned char)-1 && !p4_should_swap_ts(hwc->config, cpu)) {
>
> That cast is _extremely_ ugly. Please fix the signedness of the types instead.
>
>         Ingo
>
it's completely my fault. I'll check all occurences of this silly and
shame on me bug in a couple of hours. Sorry for this.
