Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab2FUIKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:10:19 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58360 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab2FUIKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:10:14 -0400
MIME-Version: 1.0
In-Reply-To: <4FE28823.80704@intel.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	<1340208092.21745.114.camel@twins>
	<4FE28823.80704@intel.com>
Date: Thu, 21 Jun 2012 10:10:12 +0200
Message-ID: <CABPqkBTi8-yKg_kzFTwLe1_m2Zprt5vGk9WPQW14yHQpy=PiWw@mail.gmail.com>
Subject: Re: [PATCH V6 0/13] perf: Intel uncore pmu counting support
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 4:34 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> On 06/21/2012 12:01 AM, Peter Zijlstra wrote:
>>
>> ok, so with this stuff something like:
>>
>>   perf stat -ae uncore/event=clockticks/ foo
>>
>> will register a counter per cpu, which is somewhat silly since we only
>> need one per node. What would be the best way to 'fix' this?
>>
>> We could of course create another variant of -a which iterates nodes
>> instead of cpus, -N or so.
>>
>> Alternatively we could try and describe this in sysfs in some way, one
>> possibility would be to include a link to /sys/devices/system/{cpu,node}
>> or somesuch and use that link to iterate the correct space.
>>
>> Any other suggestions?
>>
> How about treat the 'cpu' parameter for uncore event as socket id instead
> of cpu id?
>
But that does not address the use case of Peter, i.e., no cpu parameter passed.
Looks like sysfs might be the only way to do this in a portable manner.
