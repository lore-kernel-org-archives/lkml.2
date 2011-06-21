Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1FUEtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 00:49:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36662 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1FUEtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 00:49:02 -0400
Message-ID: <4E0022B5.9000500@linaro.org>
Date: Tue, 21 Jun 2011 10:18:53 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
        linux@arm.linux.org.uk, tony@atomide.com, lethal@linux-sh.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: Re: [PATCH 2/2] video: omap2: Compile omap2 support only when needed
References: <1308566761-2850-1-git-send-email-tushar.behera@linaro.org>	 <1308566761-2850-3-git-send-email-tushar.behera@linaro.org> <1308575201.2076.57.camel@deskari>
In-Reply-To: <1308575201.2076.57.camel@deskari>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 20 June 2011 06:36 PM, Tomi Valkeinen wrote:
> On Mon, 2011-06-20 at 16:16 +0530, Tushar Behera wrote:
>> Currently display support for omap2 is selected by default and
>> it gets built for all the configurations.
>>
>> Instead of it being a built-in feature, it's compilation should
>> depend on the config option CONFIG_FB_OMAP2.
>
> No, I don't think so. omap2 directory contains vram, vrfb and omapdss,
> all of which can be used without omapfb driver. vram and vrfb can be
> even used without omapdss driver.
Even if I build the kernel with i386_defconfig, I get some compiled 
files within drivers/video/omap2.

$ make ARCH=x86 i386_defconfig O=out_dir
$ make ARCH=x86 O=out_dir

$ ls out_dir/drivers/video/omap2
built-in.o  displays  modules.builtin  modules.order

IMHO, drivers/video/omap2/ should not be compiled if the kernel is not 
built for omap2.
>
> Is this patch fixing some real problem?
This patch does not fix any other problem.


>
>   Tomi
>
>


-- 
Tushar Behera
