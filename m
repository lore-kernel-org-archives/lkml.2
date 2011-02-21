Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1BUAky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 19:40:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50152 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab1BUAkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 19:40:53 -0500
MIME-Version: 1.0
X-Originating-IP: [172.22.72.244]
In-Reply-To: <1298154371-5641-7-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-7-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 16:40:51 -0800
Message-ID: <AANLkTim8i5vvizBViqFCyq9i+7Uo2E1BrNRf_gtnMb-v@mail.gmail.com>
Subject: Re: [PATCH v2 05/21] ARM: tegra: clock: Disable clocks left on by bootloader
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 19, 2011 at 2:25 PM, Colin Cross <ccross@android.com> wrote:
> Adds CONFIG_TEGRA_DISABLE_BOOTLOADER_CLOCKS that iterates
> through all clocks, disabling any for which the refcount
> is 0 but the clock init detected the bootloader left the
> clock on.


I would argue that any kernel functionality that relies on clocks
being left on my bootloader is buggy, and/or should at least have
those clocks enabled in the static clock tables for the boards in
question, since it creates an undocumented dependency on firmware.

I would prefer if it disabled the clocks by default (after warning),
but that there was a runtime way to override while debugging (i.e. add
a bootarg 'keep_fwclocks' or similar to keep the firmware-enabled
clocks running and just warn about them).


-Olof
