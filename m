Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab2IMGgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:36:36 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40739 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2IMGgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:36:31 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:d9d2:3ecd:9fd1:b4c3]
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Date: Wed, 12 Sep 2012 23:36:28 -0700
Message-ID: <CAOesGMhyQd=p23uy1Lj9iq6PKgS+kJ+xh4Z10e4XbSk50E=U7Q@mail.gmail.com>
Subject: Re: [GIT PULL] msm-core changes for v3.7
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 12, 2012 at 9:58 AM, David Brown <davidb@codeaurora.org> wrote:
> The following changes since commit 28a33cbc24e4256c143dce96c7d93bf423229f92:
>
>   Linux 3.5 (2012-07-21 13:58:29 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-core-for-3.7
>
> for you to fetch changes up to fe3a47b1c7cd74a7e39cec1fa0d89bd3724f4f65:
>
>   ARM: msm: Allow 8960 and 8660 to compile together (2012-09-12 09:31:56 -0700)
>
> ----------------------------------------------------------------
> In addition to some minor fixes, this series fully converts two
> primary MSM targets (8660 and 8960) exclusively to devicetree.  It
> removes a lot of dead code, both from the devicetree conversion, and
> code that has never been compiled.
>
> It is now possible to build both 8660 and 8960 into the same kernel.
> Not quite ready to be part of a single zImage, but at least many of
> the internal issues preventing this are resolved.

This is awesome to see, thanks for starting the platform conversion and cleanup.

I have some comments on the branch organization to make it fit the
arm-soc branch setups a bit better:

I think it could be a good idea to split off the cleanups and fixes to
a separate branch. For the other patches there seems to be enough for
at least a 'dt' branch and either a multi-platform topic branch or a
'boards' topic branch -- probably the former. So see my annotation
below for suggested sorting (I didn't check for
conflicts/dependencies).

> ----------------------------------------------------------------
> David Brown (1):
>       ARM: msm: Remove call to missing FPGA init on 8660

fixes-non-critical

> Rohit Vaswani (2):
>       ARM: msm: io: Remove 7x30 iomap region from 7x00
>       ARM: msm: io: Change the default static iomappings to be shared

fixes-non-critical

>
> Stephen Boyd (20):
>       ARM: msm: Remove msm_hw_reset_hook
>       ARM: msm: clock-pcom: Mark functions static
>       ARM: msm: Remove unused idle.c

above are cleanup

>       ARM: msm: Fix early debug uart mapping on some memory configs

fixes-non-critical

>       ARM: msm: Add handle_irq handler for 8660 DT machine
>       ARM: msm: Add msm8660-surf.dts to Makefile.boot

above are dt

>       ARM: msm: Fix sparse warnings due to incorrect type

cleanup

>       ARM: msm: Don't touch GIC registers outside of GIC code

cleanup

>       ARM: msm: Allow timer.c to compile on multiple targets

Hmm. cleanup or a separate multi-platform branch

>       ARM: msm: Add DT support to msm_timer
>       ARM: msm: Move 8660 to DT timer
>       ARM: msm: Make 8660 a DT only target
>       ARM: msm: Rename board-msm8x60 to signify its DT only status

above are dt, last maybe board but it's one of the few patches of that
topic so can be grouped with dt

>       ARM: msm: Move io mapping prototypes to common.h

cleanup

>       ARM: msm: Add DT support for 8960

dt

>       ARM: msm: Remove non-DT targets from 8960
>       ARM: msm: Remove unused acpuclock-arm11
>       ARM: msm: Remove uncompiled board-msm7x27

above are cleanup

>       ARM: msm: Allow msm_iomap-8x60 and msm_iomap-8960 to coexist
>       ARM: msm: Allow 8960 and 8660 to compile together

both of those are multi-platform or board branch

> Wei Yongjun (1):
>       ARM: msm: dma: use list_move_tail instead of list_del/list_add_tail

cleanup



-Olof
