Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0HKSq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:46:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13506 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab0HKSqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:46:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6071"; a="50546005"
Message-ID: <4C62F01E.2000708@codeaurora.org>
Date: Wed, 11 Aug 2010 11:46:54 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: uaccess: Implement strict user copy checks
References: <1280890950-19174-1-git-send-email-sboyd@codeaurora.org> <201008110504.59957.arnd@arndb.de>
In-Reply-To: <201008110504.59957.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 08:04 PM, Arnd Bergmann wrote:
>
> Do you actually need to disable this if running an older gcc? AFAICT, it
> should just have no effect at all in that case, so the comment is slightly
> misleading.

I blindly copied the help text from x86. Will fix to be less misleading.

>
> Also, why turn this specific warning into an error but not any of the other
> warnings? Some architectures (alpha, sparc, mips, powerpc, sh) simply turn
> on -Werror for architecture specific code in general, which seems very
> useful. We can also make that a config option (probably arch independent)
> that we turn on for defconfig files that we know build without warnings.
>
> Unfortunately, there is a number of device drivers that have never been
> warning-free, so we can't just enable -Werror for all code.
>

I'm following the x86 implementation. I suppose it's done this way since 
many drivers aren't warning free (as you mention) and turning on -Werror 
will make it more annoying to find these types of errors. Since there 
isn't any -Werror=user-copy this approach allows us to find this type of 
error easily without having to sift through noise.

Enabling -Werror in architecture specific code wouldn't help much here 
though right since this is going to be inlined into drivers and such?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
