Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1HIWP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 18:15:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52591 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab1HIWP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 18:15:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6433"; a="109191198"
Message-ID: <4E41B19C.3040209@codeaurora.org>
Date: Tue, 09 Aug 2011 15:15:56 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Simon Glass <sjg@google.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Dave Martin <dave.martin@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Alexander Shishkin <virtuoso@slind.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v5] ARM: Use generic BUG() handler
References: <1311926200-24806-1-git-send-email-sjg@chromium.org>
In-Reply-To: <1311926200-24806-1-git-send-email-sjg@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 12:56 AM, Simon Glass wrote:
> From: Simon Glass <sjg@google.com>
>
> ARM uses its own BUG() handler which makes its output slightly different
> from other archtectures.
>
> One of the problems is that the ARM implementation doesn't report the function
> with the BUG() in it, but always reports the PC being in __bug(). The generic
> implementation doesn't have this problem.
>
> Currently we get something like:
>
> kernel BUG at fs/proc/breakme.c:35!
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> ...
> PC is at __bug+0x20/0x2c
>
> With this patch it displays:
>
> kernel BUG at fs/proc/breakme.c:35!
> Internal error: Oops - undefined instruction: 0 [#1] PREEMPT SMP
> ...
> PC is at write_breakme+0xd0/0x1b4
>
> This implementation uses an undefined instruction to implement BUG, and sets up
> a bug table containing the relevant information. Many versions of gcc do not
> support %c properly for ARM (inserting a # when they shouldn't) so we work
> around this using distasteful macro magic.
>
> v1: Initial version to replace existing ARM BUG() implementation with something
> more similar to other architectures.
>
> v2: Add Thumb support, remove backtrace whitespace output changes. Change to
> use macros instead of requiring the asm %d flag to work (thanks to
> Dave Martin <dave.martin@linaro.org>)
>
> v3: Remove old BUG() implementation in favor of this one.
> Remove the Backtrace: message (will submit this separately).
> Use ARM_EXIT_KEEP() so that some architectures can dump exit text at link time
> thanks to Stephen Boyd <sboyd@codeaurora.org> (although since we always
> define GENERIC_BUG this might be academic.)
> Rebase to linux-2.6.git master.
>
> v4: Allow BUGS in modules (these were not reported correctly in v3)
> (thanks to Stephen Boyd <sboyd@codeaurora.org> for suggesting that.)
> Remove __bug() as this is no longer needed.
>
> v5: Add %progbits as the section flags.

Tested-by: Stephen Boyd <sboyd@codeaurora.org>

> Signed-off-by: Simon Glass <sjg@chromium.org>
> ---
>

Can you update the patch in the patch tracker? It would be great to see
this in the next merge window.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

