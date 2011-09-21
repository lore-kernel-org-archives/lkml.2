Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1IUUOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:14:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39144 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1IUUOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:14:39 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <1316633620-13184-3-git-send-email-swarren@nvidia.com>
References: <1316633620-13184-1-git-send-email-swarren@nvidia.com>
	<1316633620-13184-3-git-send-email-swarren@nvidia.com>
Date: Wed, 21 Sep 2011 13:14:38 -0700
Message-ID: <CAOesGMhdkrtjvXWHhbLSj804s+CzTthn_hrGafp5K=Va5MTZ=w@mail.gmail.com>
Subject: Re: [PATCH 3/3] arm/tegra: Move "gpio-names.h" into <mach/gpio-tegra.h>
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        Grant Likely <grant.likely@secretlab.ca>, Chris Ball <cjb@laptop.org>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 21, 2011 at 12:33 PM, Stephen Warren <swarren@nvidia.com> wrote:
> This centralizes all SoC-level GPIO-related definitions into a single
> header file.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>
>  arch/arm/mach-tegra/gpio-names.h              |  247 -------------------------
>  arch/arm/mach-tegra/include/mach/gpio-tegra.h |  225 ++++++++++++++++++++++
>  11 files changed, 226 insertions(+), 257 deletions(-)
>  delete mode 100644 arch/arm/mach-tegra/gpio-names.h

The main reason that gpio-names.h was only in the mach directory and
not under include in the first place, is to discourage use outside of
the base platform code and board definitions.

There should be no need for drivers and non-mach-tegra code to use the
file, so doing a current-directory include of it should be OK. Or do
you have other plans for it?


-Olof
