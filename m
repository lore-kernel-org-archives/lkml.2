Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab1JQHXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 03:23:12 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49677 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1JQHXK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:5:1>);
	Mon, 17 Oct 2011 03:23:10 -0400
Message-Id: <4E9BF3F8020000780005B966@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 17 Oct 2011 08:23:04 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Borislav Petkov" <bp@amd64.org>, "Tejun Heo" <tj@kernel.org>
Cc: "Andreas Herrmann3" <Andreas.Herrmann3@amd.com>,
        "Conny Seidel" <Conny.Seidel@amd.com>, "Ingo Molnar" <mingo@elte.hu>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at arch/x86/kernel/apic/apic.c:1239
	 setup_local_APIC+...
References: <20111014135516.GC11990@aftab> <20111014165604.GA14286@aftab>
 <20111014175556.GE4294@google.com>
In-Reply-To: <20111014175556.GE4294@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.10.11 at 19:55, Tejun Heo <tj@kernel.org> wrote:
> Hello,
> 
> (cc'ing Jan Beulich)
> 
> On Fri, Oct 14, 2011 at 06:56:04PM +0200, Borislav Petkov wrote:
>> On Fri, Oct 14, 2011 at 09:55:16AM -0400, Borislav Petkov wrote:
>> > So, in the end, and AFAICR, the warning triggers because we're comparing
>> > logical APIC IDs from the APIC Logical Destination Register (0xD0) which
>> > have been assigned by BIOS with "1 << cpu" shifted values which wrap on
>> > 32-bit.
>> > 
>> > I'd very much like to know why?
>> 
>> Update: upon a second thought, we think we know why: The WARN_ON
>> cannot stomach the switch to bigsmp apic because, on the one hand,
>> bigsmp_init_apic_ldr() "normalizes" the APIC ids by using the BIOS
>> values (x86_bios_cpu_apicid) but OTOH, x86_cpu_to_logical_apicid
>> contains the early percpu value which got assigned by the default apic,
>> i.e. the shifting thing as it is spec'ed for the LDR register.
>> 
>> So, the way we see it, the WARN_ON should know whether we switched apics
>> or should be removed completely. Btw, why was it added in the first
>> place, the commit message doesn't quite explain why.
> 
> Jan hit similar problem a while back.
> 
>   http://thread.gmane.org/gmane.linux.kernel/1180954 
> 
> I can't seem to find the patch in mainline.

Ingo let me know at the end of September that v2 got applied to -tip;
at that point, I took it that it would make only 3.2 (and perhaps then
earlier ones via -stable).

Jan

