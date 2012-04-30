Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2D3PFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 11:05:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55690 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2D3PFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 11:05:51 -0400
MIME-Version: 1.0
In-Reply-To: <4F9DD0A2.7010104@zytor.com>
References: <1a0aaa16-df06-40bf-88c7-28180455e6b9@email.android.com>
	<1335742410-11569-1-git-send-email-kjwinchester@gmail.com>
	<1335742410-11569-2-git-send-email-kjwinchester@gmail.com>
	<4F9DD0A2.7010104@zytor.com>
Date: Mon, 30 Apr 2012 12:05:50 -0300
Message-ID: <CAELBVzCzqZMbmGzE-dNgXogh95SNdvYWE5tHAxy1OYa+kknsCw@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] x86: Move per cpu cpu_llc_shared_map to a field in
 struct cpuinfo_x86
From: Kevin Winchester <kjwinchester@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 April 2012 20:37, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/29/2012 04:33 PM, Kevin Winchester wrote:
>> Commit 141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs from
>> 'struct cpuinfo_x86'") caused the compilation error:
>>
>> mce_amd.c:(.cpuinit.text+0x4723): undefined reference to 'cpu_llc_shared_map'
>>
>> by removing an #ifdef CONFIG_SMP around a block containing a reference
>> to cpu_llc_shared_map.  Rather than replace the #ifdef, move
>> cpu_llc_shared_map to be a new cpumask_t field llc_shared_map in
>> struct cpuinfo_x86 and adjust all references to cpu_llc_shared_map.
>>
>
> Okay...  I must not get this.
>
> Why is this better than just moving the DEFINE_PER_CPU to a place which
> isn't dependent on SMP?
>

To be honest, the idea was suggested by Ingo a while back, and I just
volunteered to implement it.  I believe the idea was to work towards
gathering all CPU-specific data for SMP and !SMP into one place.  That
said, moving the DEFINE_PER_CPU elsewhere would likely still give the
same benefits as my patch in terms of ifdef reduction.  I cannot
really see a benefit/downside either way, really.

Perhaps Ingo will chime in, and you and he (and anyone else with an
opinion) can figure out the best way of accomplishing this
simplification, and then I can adjust my series accordingly.

-- 
Kevin
