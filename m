Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2ACQIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:08:38 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35263 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab2ACQIf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:08:35 -0500
MIME-Version: 1.0
X-Originating-IP: [79.183.37.179]
In-Reply-To: <op.v7iidbwz3l0zgt@mpn-glaptop>
References: <1325600353-10895-1-git-send-email-gilad@benyossef.com>
	<op.v7iidbwz3l0zgt@mpn-glaptop>
Date: Tue, 3 Jan 2012 18:08:33 +0200
Message-ID: <CAOtvUMfWRLbXRksacPbO7qWtufsdwh07cn9ko40_A_vxhcDTUw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9] Remove useless on_each_cpu return value
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/3 Michal Nazarewicz <mina86@mina86.com>:
> On Tue, 03 Jan 2012 15:19:04 +0100, Gilad Ben-Yossef <gilad@benyossef.com>
> wrote:
>>
>> on_each_cpu() returns as its own return value the return value of
>> smp_call_function(). smp_call_function() in turn returns a hard
>> coded value of zero.
>>
>> Some callers to on_each_cpu() waste cycles and bloat code space
>> by checking the return value to on_each_cpu(), probably for
>> historical reasons.
>>
>> This patch set refactors callers to not test on_each_cpu()
>> (fixed) return value and then refactors on_each_cpu to
>> return void to avoid confusing future users.
>>
>> In other words, this patch aims to delete 18 source code lines
>> while not changing any functionality :-)
>>
>> I tested as best as I could the x86 changes and compiled some
>> of the others, but I don't have access to all the needed hardware
>> for testing. Reviewers and testers welcome!
>
>
> Other then the lack of Signed-off-by in the patches, looks good to me,

Blimey! I'll resend with a proper Signed-off-by after more people have
a chance to
comment. And thanks for the review.

> even though personally I'd choose a bottom-up approach, ie. make
> smp_call_function() return void and from that conclude that
> on_each_cpu() can return void.  With those patches, we have a situation,
> where smp_call_function() has a return value which is then lost for no
> immediately apparent reason lost in on_each_cpu().

There are so many call site of smp_call_function() that do not check the
return value right now that I think we can tolerate it for just a
little bit longer
until that get fixed as well... :-)

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
