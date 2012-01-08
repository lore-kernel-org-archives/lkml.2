Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2AHQKO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 11:10:14 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58810 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2AHQKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 11:10:11 -0500
MIME-Version: 1.0
X-Originating-IP: [79.181.26.205]
In-Reply-To: <1325854981.2442.25.camel@twins>
References: <1325600353-10895-1-git-send-email-gilad@benyossef.com>
	<1325854981.2442.25.camel@twins>
Date: Sun, 8 Jan 2012 18:10:09 +0200
Message-ID: <CAOtvUMe0pXKTrJGhkc=OFvqYS1R_PXU9qbSAP8Ld5U7NhFvCSw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9] Remove useless on_each_cpu return value
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
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
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 3:03 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-01-03 at 16:19 +0200, Gilad Ben-Yossef wrote:
>> on_each_cpu() returns as its own return value the return value of
>> smp_call_function(). smp_call_function() in turn returns a hard
>> coded value of zero.
>>
>> Some callers to on_each_cpu() waste cycles and bloat code space
>> by checking the return value to on_each_cpu(), probably for
>> historical reasons.
>
> hysterical raisins,, yumm! :-)
>
>> This patch set refactors callers to not test on_each_cpu()
>> (fixed) return value and then refactors on_each_cpu to
>> return void to avoid confusing future users.
>>
>
> Seems sane enough, fwiw:
>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks for the review :-)

I just sent out a V2. No changes except I've added the needed signed-off-by.

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
