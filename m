Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab0FENry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 09:47:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52088 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab0FENrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 09:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JQbhFvgMg57i6zhl4xtDOLOTaRBEfZlGAxLoU+pAmDXMm6zpsn5kfO8Wy9N/gO7oi+
         r4EDArfVuodUcWc2tKSuWJK+XembYAamHgShgvzbx81aXYQgR8e8zlyiILchndhNx6a9
         gnxpaDMcBUezpuvDqHPj1LTPoD0wR7OGLo1Zs=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	<20100603181010.GA25779@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
	<20100603185333.GD25779@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
	<1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
	<20100603194559.GF25779@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006031305310.8175@i5.linux-foundation.org>
	<alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org>
Date: Sat, 5 Jun 2010 16:47:50 +0300
Message-ID: <AANLkTim4ubr2R_lvxnKzdskkIO33ucdHBBAlPwVfRWGa@mail.gmail.com>
Subject: Re: ARM defconfig files
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Daniel Walker <dwalker@codeaurora.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 11:31 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, 3 Jun 2010, Linus Torvalds wrote:
>>
>> I apparently haven't explained myself enough, because what you keep on
>> harping on is not something I consider acceptable.
>>
>> STD_CONFIG is pointless. It's pointless because the solution to what
>> you call STD_CONFIG would be to just NOT USING the special Kconfig.xyz
>> file at all.
>
> To make this _really_ concrete, let me actually give you an example (but
> broken and pointless) example Kconfig file, in order to _avoid_ having a
> def_config file.
>
> I do it by generating it. Let's say that I want a x86 configuration that
> has USB enabled. I can basically _ask_ the Kconfig machinery to generate
> that with something like this:
>
>  - create a "Mykconfig" file:
>
>        config MYCONFIG
>                bool
>                default y
>                select USB
>
>        source arch/x86/Kconfig
>
> and then I just do
>
>        KBUILD_KCONFIG=Mykconfig make allnoconfig
>
> and look what appears in the .config file. In fact, do this:
>
>        make allnoconfig
>        cp .config no-config
>        KBUILD_KCONFIG=Mykconfig make allnoconfig
>        cp .config my-config
>        diff -u no-config my-config
>
> to see the point of it all.
>
> Now, the above is a _trivial_ one. And it's actually broken, because I
> should not have forced CONFIG_USB (it depends on CONFIG_USB_SUPPORT).

And that's precisely the problem that his approach doesn't solve: dependencies.

---
config MYCONFIG
	bool
	default y
	select MACH_OMAP3_BEAGLE

source arch/arm/Kconfig
---

Is the same as:
---
source arch/arm/Kconfig
---

With the SAT resolver it would be possible to have a .satconfig:
CONFIG_MACH_OMAP3_BEAGLE=y

And let the resolver figure everything out back from there.

-- 
Felipe Contreras
