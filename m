Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560Ab0FRPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 11:16:26 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37760 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab0FRPQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 11:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EChBAVelFNMOh3OT9auAbfqy4CuIR9sifkxA0n07xXGhjyjkb/yKHldCIuHNJm5BKI
         N7lm0wCWsovsrAppnSPnC7/eJUfg21b23RHnSNWaufYzEIXKzRR8W3DmbuQzRl40nz47
         Uym45OUYSD03pWPRGZWJQu4Z+oSU9eJFOs7d8=
MIME-Version: 1.0
In-Reply-To: <20100618143532.GA10886@elte.hu>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
	<20100612102558.GA4000@elte.hu>
	<4C15A5D1.1040104@jp.fujitsu.com>
	<20100618094838.GD23977@elte.hu>
	<AANLkTimqRwAjrQ_b8BZ28lEn_Gaz5-SpLULWASHD1fVn@mail.gmail.com>
	<20100618124551.GC7612@elte.hu>
	<AANLkTinaPhAcGra6JdmHCVcj9HrNyG2TP91-A8AnQMZE@mail.gmail.com>
	<20100618143532.GA10886@elte.hu>
Date: Fri, 18 Jun 2010 23:16:23 +0800
Message-ID: <AANLkTimI7efmGNeUkCVT2mUYD8LkYsLAS9chkPhZVA1E@mail.gmail.com>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
From: huang ying <huang.ying.caritas@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 10:35 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * huang ying <huang.ying.caritas@gmail.com> wrote:
>
>> On Fri, Jun 18, 2010 at 8:45 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >> >> [...] ??At least APEI will use NMI to report some hardware events (likely
>> >> >> error) to kernel. ??So I suppose we will go to have a delayed call as an
>> >> >> event handler for APEI.
>> >> >
>> >> > Yep, that makes sense. I wasnt arguing against the functionality itself, i
>> >> > was arguing against the illogical layering that limits its utility. By
>> >> > making it part of perf events it becomes a generic part of that framework
>> >> > and can be used by anything that deals with events and uses that
>> >> > framework.
>> >>
>> >> I think the the 'layering' in the patchset helps instead of 'limits' its
>> >> utility. It is designed to be as general as possible, so that it can be used
>> >> by both perf and other NMI users. Do you think so?
>> >
>> > What other NMI users do you mean? EDAC/MCE is going to go utilize events
>> > as well (away from the horrible /dev/mcelog interface), the NMI watchdog
>> > already did it and the perf tool obviously does as well. There's a few
>> > leftovers like kcrash which isnt really event centric and i dont think it
>> > needs to be converted.
>>
>> But why not just make it more general? It does not hurt anyone including
>> perf.
>
> Because it's not actually more generic that way - just look at the code. It's
> x86 specific, plus it ties it to NMI delivery while the concept of delayed
> execution has nothing to do with NMIs.

soft_irq is a delayed mechanism for IRQ, a self interrupt can be a
delayed mechanism for NMI. If we can make soft_irq NMI-safe, we can
use soft_irq as a backup of self interrupt (for systems without APIC
and maybe for other architectures).

Best Regards,
Huang Ying
