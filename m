Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1GYBWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 21:22:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49908 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab1GYBWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 21:22:42 -0400
Message-ID: <4E2CC55B.5010307@gmail.com>
Date: Mon, 25 Jul 2011 11:22:35 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: Re: GMA500: ERROR: "__bad_udelay" undefined!
References: <alpine.LNX.2.00.1107242327030.7103@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1107242327030.7103@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/07/11 07:37, Jesper Juhl wrote:
> Just got this when building the attached .config on x86_64 with gcc 4.6.1
> on up-to-date mainline git tree (head at
> b6844e8f64920cdee620157252169ba63afb0c89) :
>
>   ERROR: "__bad_udelay" [drivers/staging/gma500/psb_gfx.ko] undefined!
>   make[1]: *** [__modpost] Error 1
>
> I don't need gma500, so I've just disabled the driver to get around it but
> I thought some people might still like to know :)
>
__bad_udelay is a compile time check that constant udelays do not exceed 
a certain threshold. For x86_64 it used to be n > 20000, now it is n / 
20000 >= 1. The problem is in 
drivers/staging/gma500/psb_intel_display.c:psb_init_wait_for_vblank, 
which does udelay(20000) which under the old code would have been fine, 
but fails the new __bad_udelay check.

Possibly the udelay can just be converted to an mdelay?

~Ryan

