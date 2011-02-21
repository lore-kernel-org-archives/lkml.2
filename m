Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab1BUEXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:23:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54290 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab1BUEXW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:23:22 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298154371-5641-20-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-20-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 20:23:20 -0800
Message-ID: <AANLkTikbOQZ2jW+mfN41dXwuKVVJ3vCVKRZLezxbj61o@mail.gmail.com>
Subject: Re: [PATCH v2 18/21] ARM: tegra: cpufreq: Adjust memory frequency
 with cpu frequency
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 2:26 PM, Colin Cross <ccross@android.com> wrote:
> Signed-off-by: Colin Cross <ccross@android.com>

Patch description please. Besides that:

Acked-by: Olof Johansson <olof@lixom.net>

But note for future work:


> +       /*
> +        * Vote on memory bus frequency based on cpu frequency
> +        * This sets the minimum frequency, display or avp may request higher
> +        */
> +       if (rate >= 816000)
> +               clk_set_rate(emc_clk, 600000000); /* cpu 816 MHz, emc max */
> +       else if (rate >= 456000)
> +               clk_set_rate(emc_clk, 300000000); /* cpu 456 MHz, emc 150Mhz */
> +       else
> +               clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
> +


This hardcodes frequencies that might or might not be used on some
systems and some parts. So it'll need to be revisited when enabling
other configurations.


-Olof
