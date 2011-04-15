Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab1DOCKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 22:10:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8687 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab1DOCKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 22:10:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6316"; a="85719757"
Message-ID: <4DA7A914.5020804@codeaurora.org>
Date: Thu, 14 Apr 2011 19:10:28 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Dave Martin <dave.martin@linaro.org>, Simon Glass <sjg@google.com>
Subject: Re: [PATCH v4] ARM: Use generic BUG() handler
References: <1302822031-6752-1-git-send-email-sjg@chromium.org>
In-Reply-To: <1302822031-6752-1-git-send-email-sjg@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 04:00 PM, Simon Glass wrote:
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
> Signed-off-by: Simon Glass <sjg@chromium.org>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

