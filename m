Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2BSUpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 15:45:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56165 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885Ab2BSUpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 15:45:38 -0500
Message-ID: <4F415F55.6050902@zytor.com>
Date: Sun, 19 Feb 2012 12:45:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH][GIT PULL][v3.3] x86: Test saved %rip in NMI to determine
 nested NMI
References: <1329617173.1561.5.camel@acer.local.home>  <20120219125601.GD25900@elte.hu>  <0e44abc3-f1a9-4c5b-88a8-baa563f57067@email.android.com> <1329683679.1561.20.camel@acer.local.home>
In-Reply-To: <1329683679.1561.20.camel@acer.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2012 12:34 PM, Steven Rostedt wrote:
> On Sun, 2012-02-19 at 05:46 -0800, hpanvin@gmail.com wrote:
>> Vsyscall page, not vdso...
>
> Peter,
>
> My original patch was to check the %cs register against __KERNEL_CS, but
> IIRC, you said that userspace can change that register to anything it
> wanted before doing a long jump or something. Is this true for x86_64 as
> well? I guess it would be because x86_64 can support 32bit apps.
>
> Anyway, I'll add a check that makes sure that the RIP is less than the
> FIXADDR sections as well.
>

User space can change %cs, but it can never set it to __KERNEL_CS; 
specifically user space can never set the bottom two bits in CS to zero.

So this should be a better test.

(Now, doing the test that way plays havoc with the braindamage knows as 
Xen paravirt, but I don't think it's subject to this particular NMI code.)

	-hpa

