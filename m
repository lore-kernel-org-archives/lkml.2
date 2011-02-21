Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab1BUDnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 22:43:40 -0500
Received: from smtp-out.google.com ([74.125.121.67]:49602 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab1BUDnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 22:43:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=jIl6ubRZ0PFLq/Bahyucl1O54+vYoHNtlkW4HLcMVBN4+B6YiaiO5TNKV7/uxXVtB7
         RYyApFx/pKR9mK2w6msA==
MIME-Version: 1.0
In-Reply-To: <AANLkTim8i5vvizBViqFCyq9i+7Uo2E1BrNRf_gtnMb-v@mail.gmail.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-7-git-send-email-ccross@android.com>
	<AANLkTim8i5vvizBViqFCyq9i+7Uo2E1BrNRf_gtnMb-v@mail.gmail.com>
Date: Sun, 20 Feb 2011 19:43:35 -0800
X-Google-Sender-Auth: cpLdDp-1ar44YGTjn41cS6sXZ4Q
Message-ID: <AANLkTin_4AfAgfWu=Qq_rO2T6o=u=JX9YKHquX85HrWe@mail.gmail.com>
Subject: Re: [PATCH v2 05/21] ARM: tegra: clock: Disable clocks left on by bootloader
From: Colin Cross <ccross@android.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 4:40 PM, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
> On Sat, Feb 19, 2011 at 2:25 PM, Colin Cross <ccross@android.com> wrote:
>> Adds CONFIG_TEGRA_DISABLE_BOOTLOADER_CLOCKS that iterates
>> through all clocks, disabling any for which the refcount
>> is 0 but the clock init detected the bootloader left the
>> clock on.
>
>
> I would argue that any kernel functionality that relies on clocks
> being left on my bootloader is buggy, and/or should at least have
> those clocks enabled in the static clock tables for the boards in
> question, since it creates an undocumented dependency on firmware.
>
> I would prefer if it disabled the clocks by default (after warning),
> but that there was a runtime way to override while debugging (i.e. add
> a bootarg 'keep_fwclocks' or similar to keep the firmware-enabled
> clocks running and just warn about them).

That was the plan, but since many of the drivers are missing I didn't
want to enable it by default yet.  However, it turns out the problems
I was seeing at boot from this patch were actually due to a bug in the
clock code causing the cpu clock to be disabled for clocks that have
no disable.  I will drop this patch, and post a separate series after
these that fixes the bug and turns off clocks by default, with a
runtime argument like you suggested.
