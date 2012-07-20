Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab2GTMcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:32:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35811 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab2GTMck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:32:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120720105248.GA2692@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	<5008445B.2010109@codeaurora.org>
	<5009044E.9060908@jonmasters.org>
	<201207200828.13128.arnd@arndb.de>
	<20120720105248.GA2692@arm.com>
Date: Fri, 20 Jul 2012 14:32:39 +0200
X-Google-Sender-Auth: F_T-iHP0NlMAKozgE4aZ9Tjym9g
Message-ID: <CAMuHMdU24_7AScHyS+-xD+6rw-pw_6sP19TME4ZOpNxC+MLe_g@mail.gmail.com>
Subject: Re: [PATCH 08/36] AArch64: Kernel booting and initialisation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jon Masters <jonathan@jonmasters.org>,
        Christopher Covington <cov@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Fri, Jul 20, 2012 at 12:52 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Fri, Jul 20, 2012 at 09:28:12AM +0100, Arnd Bergmann wrote:
>> On Friday 20 July 2012, Jon Masters wrote:
>> > > I think it would be best to list the technical limitations, from the
>> > > kernel's perspective, of the unsupported exception levels and the
>> > > advantages of the supported exception levels here. If you want to guide
>> > > system builders towards EL2, I think it'd be more convincing to document
>> > > the relevant technical aspects (perhaps KVM needs facilities only
>> > > available in EL2) than just providing an unexplained requirement.
>> >
>> > Unless you enter at EL2 you can never install a hypervisor. That's the
>> > reason for the requirement for generally entering at EL2 when possible.
>>
>> How do nested hypervisors work in this scenario? Does the first-level
>> hypervisor (counting from most priviledged) provide a guest that starts
>> in an emulated EL2 state, or is this done differently?
>
> Your favourite topic :). Self virtualisation is not easily possible, at
> least not with how KVM on ARM is being implemented. The hardware does
> not allow code running at EL1 to be told that it is at EL2 (or code
> running at EL2 to be trapped at EL2). So for normal virtualisation,
> guest OSes start at EL1 and they benefit of all the hardware
> acceleration. If a guest OS wants to run KVM again, it won't have access
> to the virtualisation extensions (EL2 system register access would cause
> an undefined trap). The best it can do is run the nested guest OS in EL0
> and trap accesses to system registers (no that different from Qemu).
>
> If such feature is needed, the best approach is for all kernels, host or
> guest, to always enter at (non-secure) EL1. The EL2 would have a clearly
> defined HVC API for nested page tables, virtual interrupts, context
> switching etc. This way, the host OS can inform the hypervisor that
> guest OSes are allowed to use this API for their own nested guests. But
> getting such hypervisor API right is a bit tricky and the feedback from
> the KVM guys so far is that they need the flexibility of running their
> own code at EL2. I guess another benefit is that both KVM and Xen could
> use the same API.
>
> But is this feature really needed?

Sure :-)

A sysadmin can prevent me from running my own virtualization layer and
managing my own virtual machines (that's why UserModeLinux is so interesting).

Can software detect if it's running in EL1 or EL2 (and e.g. refuse to run)?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
