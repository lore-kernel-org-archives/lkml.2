Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab1DGFff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 01:35:35 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63262 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab1DGFfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 01:35:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6308"; a="84426413"
Message-ID: <4D9D4D23.6000805@codeaurora.org>
Date: Wed, 06 Apr 2011 22:35:31 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
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
Subject: Re: [PATCH v3] ARM: Use generic BUG() handler
References: <1302131890-20953-1-git-send-email-sjg@chromium.org>
In-Reply-To: <1302131890-20953-1-git-send-email-sjg@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/2011 4:18 PM, Simon Glass wrote:
> v3: Remove old BUG() implementation in favor of this one.
> Remove the Backtrace: message (will submit this separately).
> Use ARM_EXIT_KEEP() so that some architectures can dump exit text at link time
> thanks to Stephen Boyd <sboyd@codeaurora.org> (although since we always
> define GENERIC_BUG this might be academic.)

Its not entirely academic because CONFIG_BUG=n and CONFIG_SMP_ON_UP=n
would allow us to remove the exit text. This could be huge for people
who want to cram kernel's onto space constrained devices.

> Rebase to linux-2.6.git master.
>
> Change-Id: I07d77c832e816f5ad2390e25f466ddf750adecf4

Don't forget to remove these before submitting to the patch tracker (and
sending to the list).

> diff --git a/arch/arm/include/asm/bug.h b/arch/arm/include/asm/bug.h
> index 4d88425..2914724 100644
> --- a/arch/arm/include/asm/bug.h
> +++ b/arch/arm/include/asm/bug.h
> @@ -3,21 +3,58 @@
>  
>  
>  #ifdef CONFIG_BUG
> -#ifdef CONFIG_DEBUG_BUGVERBOSE
> -extern void __bug(const char *file, int line) __attribute__((noreturn));
> -
> -/* give file/line information */
> -#define BUG()		__bug(__FILE__, __LINE__)

Does anybody reference __bug() anymore? If not you can remove that too.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

