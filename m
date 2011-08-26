Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab1HZTSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 15:18:01 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58887 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1HZTSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 15:18:00 -0400
Message-ID: <4E57F164.6020406@gmail.com>
Date: Fri, 26 Aug 2011 13:17:56 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, ming.m.lin@intel.com
Subject: Re: [PATCH] perf: collect multiplexing timing information in perf
 record
References: <20110826152256.GA9421@quad> <4E57CA80.4070509@gmail.com> <CABPqkBTDG_DcJTPpB-126HyuT8yR+w_JOssN=ix0rAP3tjzpuw@mail.gmail.com>
In-Reply-To: <CABPqkBTDG_DcJTPpB-126HyuT8yR+w_JOssN=ix0rAP3tjzpuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/26/2011 12:02 PM, Stephane Eranian wrote:

>>> +static int
>>> +sample_read2u64(const u64 *array, u64 fmt)
>>> +{
>>> +     u64 nr = 1;
>>> +     int ret = 1; /* nr or value */
>>> +
>>> +     if (fmt & PERF_FORMAT_TOTAL_TIME_ENABLED)
>>> +             ret++;
>>> +
>>> +     if (fmt & PERF_FORMAT_TOTAL_TIME_RUNNING)
>>> +             ret++;
>>> +
>>> +     if (fmt & PERF_FORMAT_GROUP) {
>>> +             nr = *(u64 *)array;
>>> +             ret += nr;
>>> +     }
>>> +
>>> +     if (fmt & PERF_FORMAT_ID)
>>> +             ret += nr;
>>
>> Why not add
>> struct read_format {
>>        u64     value;
>>        u64     time_enabled;
>>        u64     time_running;
>>        u64     id;
>> };
>>
>> to perf_sample and save the data there?
>>
> I am not following you here.
> Are you talking about the kernel API or perf tool internals?
> 
> The only way to have timing saved in each sample is via
> PERF_SAMPLE_READ and a read_format which includes
> time_enabled + time_running.

I meant in that function you added above -- sample_read2u64. You are
moving the array pointer forward and essentially throwing away data that
was pushed to userspace. Why not add a struct and save that data for use
elsewhere in the builtin code? And the order of the data is a function
of whether PERF_FORMAT_GROUP is set (see perf_event.h file).

David

