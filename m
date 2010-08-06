Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589Ab0HFQvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 12:51:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37466 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761279Ab0HFQvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 12:51:00 -0400
X-Authority-Analysis: v=1.1 cv=6Y8H/nL8L93N+XbmwlK57FdrlxW9D5uKLQCRlCnhMcQ= c=1 sm=0 a=mQoS7KhY1GkA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=dGY8eBNhLDsapE068FAA:9 a=4U1fNIV4Vn0iHVjG-oJJOnb-rGEA:4 a=PUjeQqilurYA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [BUGFIX] trace, fix ring_buffer_read_page reading out of page
 boundary
From: Steven Rostedt <rostedt@goodmis.org>
To: Huang Ying <ying.huang@intel.com>
Cc: "srostedt@redhat.com" <srostedt@redhat.com>,
        Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1280297641.2771.307.camel@yhuang-dev>
References: <1280297641.2771.307.camel@yhuang-dev>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 06 Aug 2010 12:50:57 -0400
Message-ID: <1281113457.3352.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

Sorry for the late reply, I just got back from vacation. Note, it is
best to send to my goodmis account since I do not always check my RH
email. But ironically, I'm going through my RH email first, so I got
this first ;-)


On Wed, 2010-07-28 at 14:14 +0800, Huang Ying wrote:
> With the configuration: CONFIG_DEBUG_PAGEALLOC=y and Shaohua's patch:
> 
> [PATCH]x86: make spurious_fault check correct pte bit
> 
> Function call graph trace as follow will trigger page fault.
> 
> # cd /sys/kernel/debug/tracing/
> # echo function_graph > current_tracer
> # cat per_cpu/cpu1/trace_pipe_raw > /dev/null

Yep! I can trigger it too. I'll pull in your patch, test it and send it
out for 2.6.36 and stable.

Thanks!

-- Steve

> 
> BUG: unable to handle kernel paging request at ffff880006e99000
> IP: [<ffffffff81085572>] rb_event_length+0x1/0x3f
> PGD 1b19063 PUD 1b1d063 PMD 3f067 PTE 6e99160
> Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> last sysfs file: /sys/devices/virtual/net/lo/operstate
> CPU 1
> Modules linked in:


