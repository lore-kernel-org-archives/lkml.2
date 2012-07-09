Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab2GIO6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:58:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52020 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2GIO6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:58:41 -0400
Message-ID: <4FFAF19E.70507@gmail.com>
Date: Mon, 09 Jul 2012 08:58:38 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
References: <4FFAE6D8.5050609@gmail.com> <20120709141904.GC7298@redhat.com>  <1341843844.3462.75.camel@twins> <4FFAED16.7050204@redhat.com>  <4FFAEF13.7010108@gmail.com> <1341845396.3462.81.camel@twins> <4FFAF042.1050609@gmail.com>
In-Reply-To: <4FFAF042.1050609@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/12 8:52 AM, David Ahern wrote:
> On 7/9/12 8:49 AM, Peter Zijlstra wrote:
>> On Mon, 2012-07-09 at 08:47 -0600, David Ahern wrote:
>>>
>>> I found this testing changes to perf-kvm, but found the problem extends
>>> to just perf-record. With perf-record exclude_guest defaults to 1. See
>>> tools/perf/util/util.c, event_attr_init().
>>
>> You lost me there.. so perf-record defaults to exclude_guest=1 (which
>> would make the proposed patch I just send actually possible), but its
>> still going *bang* ?
>>
>
>
> I can do the formality of testing your proposed patch, but yes I think
> so. exclude_guest defaults to 1 because perf_guest defaults to false.


Let me dig for a few minutes. exclude_user is getting reset somewhere. 
Setting a breakpoint on sys_perf_event_open and dumping the attribute:

$1 = {type = 0, size = 80, config = 0, {sample_period = 4000, 
sample_freq = 4000}, sample_type = 263, read_format = 7,
   disabled = 1, inherit = 1, pinned = 0, exclusive = 0, exclude_user = 
0, exclude_kernel = 0, exclude_hv = 0, exclude_idle =
     0, mmap = 1, comm = 1, freq = 1, inherit_stat = 0, enable_on_exec = 
1, task = 0, watermark = 0, precise_ip = 1,
   mmap_data = 0, sample_id_all = 1, exclude_host = 0, exclude_guest = 
0, __reserved_1 = 0, {wakeup_events = 0,
     wakeup_watermark = 0}, bp_type = 0, {bp_addr = 0, config1 = 0}, 
{bp_len = 0, config2 = 0}, branch_sample_type = 0}


