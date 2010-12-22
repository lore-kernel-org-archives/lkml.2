Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab0LVWUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 17:20:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791Ab0LVWUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 17:20:19 -0500
Date: Wed, 22 Dec 2010 14:19:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Drake <dsd@laptop.org>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, pgf@laptop.org, rjw@sisk.pl,
        stable@kernel.org
Subject: Re: [PATCH v3] rtc-cmos: fix suspend/resume
Message-Id: <20101222141947.94322b9c.akpm@linux-foundation.org>
In-Reply-To: <20101219190828.A6C189D401C@zog.reactivated.net>
References: <20101219190828.A6C189D401C@zog.reactivated.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Dec 2010 19:08:28 +0000 (GMT)
Daniel Drake <dsd@laptop.org> wrote:

> From: Paul Fox <pgf@laptop.org>
> 
> rtc-cmos was setting suspend/resume hooks at the device_driver level.
> However, the platform bus code (drivers/base/platform.c) only looks
> for resume hooks at the dev_pm_ops level, or within the platform_driver.
> 
> Switch rtc_cmos to use dev_pm_ops so that suspend/resume code is
> executed again.
> 
> Signed-off-by: Paul Fox <pgf@laptop.org>
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  drivers/rtc/rtc-cmos.c |   16 +++++++++-------
>  1 files changed, 9 insertions(+), 7 deletions(-)
> 
> v2: incorporate feedback from Rafael J. Wysocki, fix tabs, make a bit more
> consistent with typical SIMPLE_DEV_PM_OPS users.
> 
> v3: remove const keyword already set by macro, thanks to Rafael

It's unclear what the user-visible effects of this bug were.  Machine
fails to suspend?  RTC loses its brains on resume?  Something else?

That's really important information for a bugfix's changelog.  Please
never omit it.



I'm going to assume that whatever-the-behaviour-is is fairly serious,
and that we want this patch in 2.6.37.  So I tagged it for backporting
into 2.6.37.1, as we're getting pretty close to 2.6.37.

The patch also applies to 2.6.36.  Is it needed there?  And in earlier
kernels?

