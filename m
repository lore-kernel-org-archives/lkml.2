Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2CHSX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:23:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41585 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab2CHSXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:23:53 -0500
Date: Thu, 8 Mar 2012 10:23:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH] staging: ram_console: Fix section mismatches
Message-ID: <20120308182349.GB32187@kroah.com>
References: <1331170478-30538-1-git-send-email-john.stultz@linaro.org>
 <1331197684-9163-1-git-send-email-sboyd@codeaurora.org>
 <20120308175645.GA22682@kroah.com>
 <4F58F677.8030102@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F58F677.8030102@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 10:12:07AM -0800, Stephen Boyd wrote:
> On 03/08/12 09:56, Greg KH wrote:
> > On Thu, Mar 08, 2012 at 01:08:04AM -0800, Stephen Boyd wrote:
> >> WARNING: vmlinux.o(.text+0x25d5fc): Section mismatch in reference
> >> from the function ram_console_driver_probe() to the function
> >> .init.text:ram_console_init()
> >> The function ram_console_driver_probe() references
> >> the function __init ram_console_init().
> >> This is often because ram_console_driver_probe lacks a __init
> >> annotation or the annotation of ram_console_init is wrong.
> >>
> >> Mark ram_console_driver_probe() as __devinit because it's a probe
> >> function and propagate the __devinit markings to the __init
> >> functions the probe calls.
> > What .config configuration causes this to happen?  I don't see this here
> > in my builds, what am I doing wrong?
> >
> 
> #
> # Android
> #
> CONFIG_ANDROID=y
> # CONFIG_ANDROID_BINDER_IPC is not set
> # CONFIG_ASHMEM is not set
> # CONFIG_ANDROID_LOGGER is not set
> CONFIG_ANDROID_RAM_CONSOLE=y
> # CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION is not set
> # CONFIG_ANDROID_TIMED_OUTPUT is not set
> # CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
> # CONFIG_ANDROID_SWITCH is not set
> # CONFIG_PHONE is not set
> 
> 
> Perhaps you're missing this patch if you're on an ARM compiler?
> 
> 6e2e340 (ARM: 7324/1: modpost: Fix section warnings for ARM for many
> compilers, 2012-02-14)

Nope, I'm building this on x86-64 which warns on this type of thing all
the time.

My .config looks like this:

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ASHMEM=y
CONFIG_ANDROID_LOGGER=m
CONFIG_ANDROID_PERSISTENT_RAM=y
CONFIG_ANDROID_RAM_CONSOLE=y
CONFIG_ANDROID_TIMED_OUTPUT=y
# CONFIG_ANDROID_TIMED_GPIO is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
CONFIG_ANDROID_SWITCH=m
CONFIG_ANDROID_SWITCH_GPIO=m
CONFIG_ANDROID_INTF_ALARM=y
CONFIG_ANDROID_INTF_ALARM_DEV=y
CONFIG_ANDROID_ALARM_OLDDRV_COMPAT=y

And I can't duplicate this at all.  Could the recent fixes that John
sent me be the reason?  Or something else?

thanks,

greg k-h
