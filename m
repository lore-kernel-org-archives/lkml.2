Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1BUE2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:28:16 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59475 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab1BUE2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:28:12 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298154371-5641-22-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-22-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 20:28:11 -0800
Message-ID: <AANLkTin-=rv8HoUhUYJbfrsXHHE7iysqdC+W97C-_bM=@mail.gmail.com>
Subject: Re: [PATCH v2 20/21] ARM: tegra: clock: Fix clock issues in suspend
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 2:26 PM, Colin Cross <ccross@android.com> wrote:
> The PLLP registers are now being restored by the low-level resume code,
> and the CPU may be running off PLLP, so don't touch them during clock
> resume.
>
> Save plld, plls, pllu, and audio clock during suspend (originally
> fixed by Mayuresh Kulkarni <mkulkarni@nvidia.com>)
>
> The lock time for plld is 1000 us, so increase the delay after
> setting the PLLs.
>
> Add a BUG_ON to ensure the size of the suspend context area is
> correct.

It's a bummer that this can't be done (easily) at build time, it'd be
more useful. Oh well, still good to catch at runtime at least.


> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Olof Johansson <olof@lixom.net>
