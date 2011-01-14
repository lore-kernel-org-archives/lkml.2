Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab1ANBOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:14:37 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:63251 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab1ANBOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:14:32 -0500
Message-ID: <4D2FA305.2030808@kernel.org>
Date: Thu, 13 Jan 2011 17:12:37 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] x86: Add safe_udelay() and safe_msleep()
References: <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com> <20110111135655.GA6901@kroah.com> <4D2CFEAD.6070206@kernel.org> <1294799565.9586.13.camel@pasglop> <4D2F7AE9.2000809@kernel.org> <20110113224450.GA14918@kroah.com> <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6> <4D2F84FC.7000804@kernel.org> <20110113234852.GB17904@kroah.com> <4D2F9948.8000804@kernel.org> <20110114004428.GA26847@kroah.com>
In-Reply-To: <20110114004428.GA26847@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 04:44 PM, Greg KH wrote:
> On Thu, Jan 13, 2011 at 04:31:04PM -0800, Yinghai Lu wrote:
>> there are some udelay() in drivers/usb/early/ehci-dbgp.c
>>
>> that is for early USB debug port console support.
>>
>> We should replace them with early version udelay()
> 
> Again, I fail to see why.  They work fine today, right?

did not test that for a while.

from code review, we should not use udelay() that early.

in arch/x86/lib/delay.c we have
inline void __const_udelay(unsigned long xloops)
{
        int d0;

        xloops *= 4;
        asm("mull %%edx"
                :"=d" (xloops), "=&a" (d0)
                :"1" (xloops), "0"
                (this_cpu_read(cpu_info.loops_per_jiffy) * (HZ/4)));

        __delay(++xloops);
}
EXPORT_SYMBOL(__const_udelay);

that percpu cpu_info.loops_per_jiffy only have value after smp_prepare_cpus() is called.

> 
> You _really_ need to prove what you are trying to do here, with lots of
> details and descriptions of what the problem is, as it's getting a bit
> annoying...

sorry for that.

Yinghai
