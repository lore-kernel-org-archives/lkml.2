Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab2GCNHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:07:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39187 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab2GCNHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:07:50 -0400
Message-ID: <4FF2EEA1.6080204@linaro.org>
Date: Tue, 03 Jul 2012 14:07:45 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
References: <1341316788-12730-1-git-send-email-lee.jones@linaro.org> <20120703123552.GC25995@sirena.org.uk>
In-Reply-To: <20120703123552.GC25995@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/12 13:35, Mark Brown wrote:
> On Tue, Jul 03, 2012 at 12:59:48PM +0100, Lee Jones wrote:
>> We register the ab8500 as an MFD device from db8500 code during Device Tree
>> boot in order to solve some limitations of DT. However, when Device Tree is
>> not enabled, we still want to allow platform code to register the ab8500 in
>> the normal way. Here we force MFD device registration of the ab8500 only
>> when booting with Device Tree enabled.
>>
>> Solves this issue:
>> WARNING: at fs/sysfs/dir.c:526 sysfs_add_one+0x88/0xb0()
>> sysfs: cannot create duplicate filename '/bus/platform/devices/ab8500-core.0'
>
> Do we really want to create MFD cells like this (which are really Linux
> internal things and might vary if another OS or another version of Linux
> changes its internal abstractions) from the device tree?

We're not creating them. We're merely using current infrastructure.

Before, when we probed each device from Device Tree we came up against 
some fairly major limitations of the Device Tree. As a result, Arnd and 
I agreed that this was the way to go.

See c5395e7ed8f16cc7bb72a783de68659db5aed515 for a short description of 
the troubles we faced.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


