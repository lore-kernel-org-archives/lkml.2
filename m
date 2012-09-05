Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab2IEMIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:08:13 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61795 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2IEMIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:08:11 -0400
MIME-Version: 1.0
In-Reply-To: <504739B8.10604@st.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
	<1346839153-6465-3-git-send-email-loic.pallardy-ext@stericsson.com>
	<201209051042.00887.arnd@arndb.de>
	<504739B8.10604@st.com>
Date: Wed, 5 Sep 2012 14:08:10 +0200
Message-ID: <CACRpkdY2d1dGcV0OArM+vY29HZisXeA583D46p8rmiUSGeS27g@mail.gmail.com>
Subject: Re: [PATCH 02/17] arm: ux500: add ccu9540 board support
From: Linus Walleij <linus.walleij@linaro.org>
To: Loic PALLARDY <loic.pallardy@st.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Loic PALLARDY STE <loic.pallardy-ext@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.com>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 1:38 PM, Loic PALLARDY <loic.pallardy@st.com> wrote:
> On 09/05/2012 12:42 PM, Arnd Bergmann wrote:
>> On Wednesday 05 September 2012, Loic Pallardy wrote:
>>> +MACHINE_START(U9540, "ST-Ericsson 9540 platform")
>>> +       .atag_offset    = 0x100,
>>> +       .map_io         = u8500_map_io,
>>> +       .nr_irqs        = UX500_NR_IRQS,
>>> +       .init_irq       = ux500_init_irq,
>>> +       .timer          =&ux500_timer,
>>> +       .handle_irq     = gic_handle_irq,
>>> +       .init_machine   = u9540_init_machine,
>>> +       .init_late      = ux500_init_late,
>>> +MACHINE_END
>>
>> Please don't add another ATAG based board definition to ux500. We're closing in
>> on having full support for DT booting with this platform, so your patch is just
>> making it harder for us to complete this.
>>
>>       Arnd
> Yes I know and agree.
> Please consider this patch as a temporary one waiting for 9540 support
> from Lee.

It seems it would still be possible to create a patch series containing
just the PRCMU refactorings (which are really nice) and necessary
modifications to the MOP500 series so we could get this ground work
into the 3.7 merge window (if Sam is happy with it).

Actually it'd be nice to have a patch series containing that *and*
Lee's recent patches for e.g. IRQ domain on the PRCMU in one
big series, that would prepare the ground very nicely, then only
the DT board stuff would be missing for a successful U9540 DT
boot.

Is this possible?

Yours,
Linus Walleij
