Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2CJCDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 21:03:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18487 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab2CJCDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 21:03:14 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=mx00zOLDafsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=1fitlbfCT6V4qjbYaA0A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331344992.25686.612.camel@gandalf.stny.rr.com>
Subject: Re: 3.0.23-rt39 BUG: scheduling while atomic, _cpu_down()
From: Steven Rostedt <rostedt@goodmis.org>
To: frank.rowand@am.sony.com
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Date: Fri, 09 Mar 2012 21:03:12 -0500
In-Reply-To: <4F5AB3B6.2040705@am.sony.com>
References: <4F5AB3B6.2040705@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 17:51 -0800, Frank Rowand wrote:
> Hi Thomas,
> (and Steve, since you've been mucking about in the hotplug code,)
> 
> Yet another bit of fallout related to hotplug.
> 
> This appears to affect 3.0-rt1, 3.0.23-rt29, and 3.2.9-rt17.
> (Thus probably all 3.x versions, but I haven't been masochistic
> enough to check.)
> 
> If not defined CONFIG_PREEMPT_RT_FULL then

So you're saying that there's a bug with PREEMPT_RT off?

> 
>   - hotplug_lock() is a mutex_lock()
>   - cpu_hotplug_begin() calls hotplug_lock()
>   - _cpu_down() calls cpu_hotplug_begin() with preemption
>     disabled (disabled by the migrate_disable())
> 
> The call to cpu_hotplug_begin() is not in a preempt disabled
> region until hotplug-use-migrate-disable.patch.  This patch
> moves the preempt_enable() (aka migrate_enable()) from just
> before calling cpu_hotplug_begin() to after "out_cancel:".
> 
> The BUG can be triggered by:
> 
>    echo 0 > /sys/devices/system/cpu/cpu1/online 

Note, there's a lot more wrong with hotplug in rt than this. The hotplug
code really needs a total rewrite for RT to work with it. It probably
should have a total rewrite in mainline anyway.

-- Steve


