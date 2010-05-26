Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab0EZHRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:17:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59444 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab0EZHRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:17:54 -0400
Message-ID: <4BFCCBB0.6040101@cn.fujitsu.com>
Date: Wed, 26 May 2010 15:20:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Chase Douglas <chase.douglas@canonical.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Soeren Sandmann <sandmann@daimi.au.dk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Tracing configuration review
References: <1274815906.9757.83.camel@cndougla-ubuntu>	<20100525201259.GA5370@nowhere> <AANLkTinuHB9gPLBZs_QsHqOm6Y5nR91P_gFlVBXa-ilJ@mail.gmail.com>
In-Reply-To: <AANLkTinuHB9gPLBZs_QsHqOm6Y5nR91P_gFlVBXa-ilJ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Tue, May 25, 2010 at 11:13 PM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
>>> # CONFIG_KMEMTRACE is not set (Kconfig says N if unsure)
>> Deprecated. We have the kmem trace event that are a full replacement now.
>> Pekka, Gabriel, can we remove it now?
> 
> I don't think ftrace supports boot-time tracing which kmemtrace did.

We can do boot-time tracing by passing "trace_event=" kernel parameter.

By passing "ftrace=kmemtrace", kmemtrace can be started when
calling tracer_alloc_buffer(), which is an early_initcall.
While trace events are inititialized as a fs_initcall,  it can
be modified to an early_initcall.

Furthermore, I noticed the discussion on perf persistent events, which
seems to enable perf trace at boot time, so I think perf-kmem can take
advantage of this and will be a full-replacement of kmemtrace soon ?

> That said, I was probably the only one actually using the feature so
> maybe we can just nuke kmemtrace at this point...

If you agree on removing kmemtrace now, I'll re-send the patch.

