Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335Ab0EXXcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:32:24 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:12694 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab0EXXcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:32:12 -0400
X-SpamScore: -32
X-BigFish: VPS-32(zz1432P1453M98dN936eM9371Pzz1202hzzz2fh2a8h61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4BFB0C77.2030904@am.sony.com>
Date: Mon, 24 May 2010 16:32:07 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Iram Shahzad <iram.shahzad@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FUNCTION_TRACER: can it be used to trace early bootup functions
References: <06EE497F774E482693005209CB740D6A@rainbow>
In-Reply-To: <06EE497F774E482693005209CB740D6A@rainbow>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2010 11:55 PM, Iram Shahzad wrote:
> Hi
> 
> I would like to know whether the Kernel Function Tracer
> (kernel/trace/trace_functions) be used to trace early kernel
> bootup functions starting from start_kernel?
> My arch is ARM, by the way.
>
> 
> I have done some trials but it doesn't seem to trace early
> bootup functions. I even made it the default tracer replacing
> the nop tracer, but still it doesn't give me trace from
> start_kernel.
> 
> Looking at the source code, it seems to me that it starts
> recording data only after its own initialization. So does it
> mean that by design it does not support early tracing?
By design, the trace code is initialized during
initcall processing.  This means you miss all initialization
up to this point in the kernel.

Measuring this on my own ARM platforms, I have found that
this results in missing about the first 50 milliseconds
of kernel initialization (from start_kernel() to the
tracer initialization).  For me, this is not a big
problem.  Note that you can't measure the period
of time from start_kernel() to whenever the ARM memory
and clocks are initialized.

IMHO the best way to measure stuff between the end
of bootloader and tracer initialization is with an
external tracer, like http://elinux.org/Grabserial
and using CONFIG_DEBUG_LL, and your own calls to
printascii() on ARM.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Network Entertainment
=============================

