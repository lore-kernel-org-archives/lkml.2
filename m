Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab0IQL2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 07:28:43 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:60199 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753618Ab0IQL2m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 07:28:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:X-User-Agent:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:Date:To:CC:Message-ID:X-Identified-User;
	b=A5oBz5EOnOGYX0Z0GM7yPY4YGBZXCpXzErKJ4Az+7EB6R0Rn6BqeWuRPVnfwRhbm1NLyBHS3kp5kbI6U+gF3nWqFa5dTs8Fp118nSO1XvC/bK8OqFZD9MZB+UJOcC4NK;
X-User-Agent: K-9 Mail for Android
References: <201009132336.17310.anarsoul@gmail.com> <20100914224111.GA14467@sucs.org> <201009161803.10531.anarsoul@gmail.com> <201009171002.09187.simon.farnsworth@onelan.co.uk>
In-Reply-To: <201009171002.09187.simon.farnsworth@onelan.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [Intel-gfx] Interrupt latency on some 945GM platforms
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Fri, 17 Sep 2010 13:30:26 -0300
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
        intel-gfx@lists.freedesktop.org
CC: Vasily Khoruzhick <anarsoul@gmail.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Message-ID: <4b4d1e0a-b1ad-40f1-a829-6d4726d2b2d3@email.android.com>
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 195.83.197.130 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah if that works we could definitely add some qos calls to the driver.  When vblanks are alive we'd need a latency less tha the refresh rate, and when commands are oustanding we'd probably want it even lower.

Vasily, can you try the qos workaround on your machine and see if it works too?

Thanks,

"Simon Farnsworth" <simon.farnsworth@onelan.co.uk> wrote:

>On Thursday 16 September 2010, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
>> В сообщении от 15 of September 2010 01:41:11 автор Sitsofe Wheeler написал:
>> > > >     processor.max_cstate=2
>> > > 
>> > > Nope, it doesn't work with max_cstate=2
>> > 
>> > Perhaps intel_idle is being used? Any mention of it in dmesg?
>> 
>> Sitsofe, maybe you misunderstood me, I mean with max_cstate=1 graphics is
>> smooth, with higher values (i.e. max_cstate=2) graphics is jerky.
>> 
>> Btw, Jesse, any comments/solutions/workarounds except one with
>> processor.max_cstate=1 in kernel commandline? Should I file a bug on fdo
>> bugzilla?
>
>This looks like a problem I've seen on some hardware.
>
>My workaround has been to use the pm_qos /dev/cpu_dma_latency interface to 
>request a maximum latency of 1ms (value chosen as definitely small enough - a 
>larger value may be better, but I don't care about power saving at runtime on 
>my kit).
>
>If it's happening on other kit, perhaps the i915 driver should make a suitable 
>pm_qos request itself. Jesse, can you comment?
>-- 
>Simon Farnsworth
>Software Engineer
>ONELAN Limited
>http://www.onelan.com/
>

-- 
Jesse Barnes, Intel Open Source Technology Center
