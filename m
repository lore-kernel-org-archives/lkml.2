Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab2GZOPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:15:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40733 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2GZOPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:15:04 -0400
Message-ID: <501150E5.6010503@linaro.org>
Date: Thu, 26 Jul 2012 15:15:01 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 20/21] ASoC: codecs: Enable AB8500 CODEC for Device Tree
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org> <1343298534-13611-21-git-send-email-lee.jones@linaro.org> <20120726115055.GD3099@opensource.wolfsonmicro.com>
In-Reply-To: <20120726115055.GD3099@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry missed this:

>>   	{
>>   		.name = "ab8500-codec",
>> +		.of_compatible = "stericsson,ab8500-codec",
>>   	},
>
> Why are we doing this?  The MFD cells are a totally Linux specific
> thing, there's no reason to represent them in the device tree unless
> they're in some way reusable and the "ab8500-codec" name suggests that's
> unlikely.  Just put the properties on the parent node and instantiate
> the MFD cell as normal.

We have all of the AB8500 devices into the Device Tree to accurately 
represent the hardware. We will also be passing configuration 
information into the AB8500 Codec from Device Tree. The only reason 
we're still registering them using the MFD API is to overcome addressing 
issues encountered earlier. Each 'device' still belongs in the 'device' 
tree.

If we were to take this Device Tree and use it on something non-Linux, 
that OS will still need to know about each of the AB8500 devices and 
every associated configuration option. Only in Linux do we continue to 
register them though a different API, which doesn't affect any other OS.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
