Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2CHSMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:12:14 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36398 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab2CHSMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:12:10 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6643"; a="170721488"
Message-ID: <4F58F677.8030102@codeaurora.org>
Date: Thu, 08 Mar 2012 10:12:07 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH] staging: ram_console: Fix section mismatches
References: <1331170478-30538-1-git-send-email-john.stultz@linaro.org> <1331197684-9163-1-git-send-email-sboyd@codeaurora.org> <20120308175645.GA22682@kroah.com>
In-Reply-To: <20120308175645.GA22682@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/12 09:56, Greg KH wrote:
> On Thu, Mar 08, 2012 at 01:08:04AM -0800, Stephen Boyd wrote:
>> WARNING: vmlinux.o(.text+0x25d5fc): Section mismatch in reference
>> from the function ram_console_driver_probe() to the function
>> .init.text:ram_console_init()
>> The function ram_console_driver_probe() references
>> the function __init ram_console_init().
>> This is often because ram_console_driver_probe lacks a __init
>> annotation or the annotation of ram_console_init is wrong.
>>
>> Mark ram_console_driver_probe() as __devinit because it's a probe
>> function and propagate the __devinit markings to the __init
>> functions the probe calls.
> What .config configuration causes this to happen?  I don't see this here
> in my builds, what am I doing wrong?
>

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# CONFIG_ASHMEM is not set
# CONFIG_ANDROID_LOGGER is not set
CONFIG_ANDROID_RAM_CONSOLE=y
# CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION is not set
# CONFIG_ANDROID_TIMED_OUTPUT is not set
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
# CONFIG_ANDROID_SWITCH is not set
# CONFIG_PHONE is not set


Perhaps you're missing this patch if you're on an ARM compiler?

6e2e340 (ARM: 7324/1: modpost: Fix section warnings for ARM for many
compilers, 2012-02-14)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

