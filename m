Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab1HLX3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 19:29:20 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:34549 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1HLX3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 19:29:18 -0400
MIME-Version: 1.0
In-Reply-To: <1313183070-16724-1-git-send-email-mikew@google.com>
References: <1313183070-16724-1-git-send-email-mikew@google.com>
Date: Fri, 12 Aug 2011 16:29:17 -0700
X-Google-Sender-Auth: GxUxNA_Xl5To9Sfa2rULWRJrJtc
Message-ID: <CANcMJZBV5guSaP5kPKgfujoFJycNn9y8bYtZv6L7jpjnhkh6Hw@mail.gmail.com>
Subject: Re: [PATCH] rtc: Initialized rtc_time->tm_isdst
From: john stultz <johnstul@us.ibm.com>
To: Mike Waychison <mikew@google.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 2:04 PM, Mike Waychison <mikew@google.com> wrote:
> Even though the Linux kernel does not use the tm_isdst field, it is
> exposed as part of the ABI.  This field can accidentally be left
> initialized, which is why we currently memset buffers returned to
> userland in rtc_read_time.
>
> There is a case however where the field can return garbage from the
> stack though when using the RTC_ALM_READ ioctl on the rtc device.  This
> ioctl invokes rtc_read_alarm, which is careful to memset the rtc_wkalrm
> buffer that is copied to userland, but it then uses a struct copy to
> assign to alarm->time given the return value from rtc_ktime_to_tm().
>
> rtc_ktime_to_tm() is implemented by calling rtc_time_to_tm using a
> derivative seconds counds from ktime, but rtc_time_to_tm does not assign
> a value to ->tm_isdst.  This results in garbage from rtc_ktime_to_tm()'s
> frame ending up being copied out to userland as part of the returned
> rtc_wkalrm.

Thanks for catching this!  I've queued this in my tree.

thanks
-john
