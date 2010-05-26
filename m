Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab0EZJJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 05:09:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61280 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab0EZJJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 05:09:56 -0400
Message-ID: <4BFCE5F2.4070906@cn.fujitsu.com>
Date: Wed, 26 May 2010 17:12:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chase Douglas <chase.douglas@canonical.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Soeren Sandmann <sandmann@daimi.au.dk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Tracing configuration review
References: <1274815906.9757.83.camel@cndougla-ubuntu> <20100525201259.GA5370@nowhere> <AANLkTinuHB9gPLBZs_QsHqOm6Y5nR91P_gFlVBXa-ilJ@mail.gmail.com> <4BFCCBB0.6040101@cn.fujitsu.com> <20100526084201.GA22438@localhost>
In-Reply-To: <20100526084201.GA22438@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard - Gabriel Munteanu wrote:
> On Wed, May 26, 2010 at 03:20:16PM +0800, Li Zefan wrote:
>> Pekka Enberg wrote:
>>> On Tue, May 25, 2010 at 11:13 PM, Frederic Weisbecker
>>> <fweisbec@gmail.com> wrote:
>>>>> # CONFIG_KMEMTRACE is not set (Kconfig says N if unsure)
>>>> Deprecated. We have the kmem trace event that are a full replacement now.
>>>> Pekka, Gabriel, can we remove it now?
>>> I don't think ftrace supports boot-time tracing which kmemtrace did.
>> We can do boot-time tracing by passing "trace_event=" kernel parameter.
>>
>> By passing "ftrace=kmemtrace", kmemtrace can be started when
>> calling tracer_alloc_buffer(), which is an early_initcall.
>> While trace events are inititialized as a fs_initcall,  it can
>> be modified to an early_initcall.
>>
>> Furthermore, I noticed the discussion on perf persistent events, which
>> seems to enable perf trace at boot time, so I think perf-kmem can take
>> advantage of this and will be a full-replacement of kmemtrace soon ?
>>
>>> That said, I was probably the only one actually using the feature so
>>> maybe we can just nuke kmemtrace at this point...
>> If you agree on removing kmemtrace now, I'll re-send the patch.
> 
> I don't understand... wasn't the old kmemtrace (the relayfs based stuff)
> removed a long time ago? Right now it's just the hooks and code that
> sets up tracing and printers.
> 
> Or does it happen that that code isn't necessary for 'perf kmem' to do
> its job?
> 

Yes, actually the code has nothing to do with perf-kmem.

> And yeah, I'm all for the perf stuff, kmemtrace-user (the out-of-tree
> userspace tools) has been obsolete since the shift to ftrace.
> 
> As for early tracing, that was possible with the relayfs variant, it
> required only the SLAB layer to be up IIRC. But that stopped working
> once it got converted to ftrace (kmemtrace_init() is a nop).
> 

Ah, thanks for making this clear, so there's no such early tracing
feature that acts as a barrier in removing kmemtrace.

