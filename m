Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab1BVF0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 00:26:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51820 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab1BVF0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 00:26:06 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298342392-21236-3-git-send-email-ccross@android.com>
References: <1298342392-21236-1-git-send-email-ccross@android.com>
	<1298342392-21236-3-git-send-email-ccross@android.com>
Date: Mon, 21 Feb 2011 21:26:04 -0800
Message-ID: <AANLkTikV4++xA6JCh2yx_krdJrFddioZjBWe9pHP0b-x@mail.gmail.com>
Subject: Re: [PATCH 2/7] ARM: tegra: clock: Round rate before setting rate
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, konkers@android.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mike@compulab.co.il, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 6:39 PM, Colin Cross <ccross@android.com> wrote:
> Call the clock's round_rate op, if it exists, before calling
> the set_rate op.  This will help later when dvfs is added,
> dvfs needs to know what the final rate will be before the
> frequency changes.
>
> Also requires fixes to the round rate functions to ensure
> calling round rate and then set rate will not cause the
> frequency to be rounded down twice.  When picking clock
> divider values, the clock framework picks the closest
> frequency that is lower than the requested frequency.  If
> the new frequency calculated from the divider value is
> rounded down, and then passed to set_rate, it will get
> rounded down again, possibly resulting in a frequency two
> steps lower than the original requested frequency.
>
> Fix the problem by rounding up when calculating the frequency
> coming out of a clock divider, so if that frequency is
> requested again, the same divider value will be picked.
>
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Olof Johansson <olof@lixom.net>
