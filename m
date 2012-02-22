Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab2BVMY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 07:24:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56976 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2BVMYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:24:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kjwinchester@gmail.com designates 10.205.133.147 as permitted sender) smtp.mail=kjwinchester@gmail.com; dkim=pass header.i=kjwinchester@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120222092745.GA30339@elte.hu>
References: <20120221153935.GE2486@x1.osrc.amd.com>
	<1329875144-560-1-git-send-email-kjwinchester@gmail.com>
	<1329875144-560-2-git-send-email-kjwinchester@gmail.com>
	<4F448DBD.6030300@zytor.com>
	<20120222092745.GA30339@elte.hu>
Date: Wed, 22 Feb 2012 08:24:23 -0400
Message-ID: <CAELBVzBFtOjed_YoMZm_Crfr6ccs2UnoYT-QDDaHcX0uNf0NpQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] x86: Move per cpu cpu_llc_shared_map to a field in
 struct cpuinfo_x86
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 February 2012 05:27, Ingo Molnar <mingo@elte.hu> wrote:
>
> * H. Peter Anvin <hpa@zytor.com> wrote:
>
>> On 02/21/2012 05:45 PM, Kevin Winchester wrote:
>> > Commit 141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs from
>> > 'struct cpuinfo_x86'") caused the compilation error:
>> >
>> > mce_amd.c:(.cpuinit.text+0x4723): undefined reference to 'cpu_llc_shared_map'
>> >
>> > by removing an #ifdef CONFIG_SMP around a block containing a
>> > reference to cpu_llc_shared_map.  Rather than replace the
>> > #ifdef, move cpu_llc_shared_map to be a new cpumask_t field
>> > llc_shared_map in struct cpuinfo_x86 and adjust all
>> > references to cpu_llc_shared_map.
>> >
>>
>> I'm not comfortable with a patch this large after we are
>> already at -rc4.  Please send a minimal patch to fix the
>> failure for v3.3, and then a patch on top of that which we can
>> queue up with the rest of the patchset to for v3.4.
>
> I forgot about the v3.3 aspect of the series - yes, you are
> right, doing it like that would be preferred.
>
> It can all be in the same series, we'll sort apart the v3.3 and
> v3.4 bits.
>

That seems quite reasonable, I was not really thinking about v3.3 or
v3.4 at all when working on this.  Can I suggest, then, that you apply
Borislav's original patch:

https://lkml.org/lkml/2012/2/3/331

for now, and then I will rebase on top of that and remove the #ifdefs
as part of my first patch?

-- 
Kevin Winchester
