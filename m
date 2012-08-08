Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030477Ab2HHR3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:29:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56046 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822Ab2HHR3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:29:01 -0400
Message-ID: <5022A1DA.5000203@wwwdotorg.org>
Date: Wed, 08 Aug 2012 11:28:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: olof@lixom.net, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 0/3] ARM: dt: tegra: cardhu: add entry for regulators
References: <1344408527-32051-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1344408527-32051-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 12:48 AM, Laxman Dewangan wrote:
> This patch series add the PMIC and fixed regulators for 
> cardhu board. There is multiple versions of cardhu baord named
> as A01, A02, A03..and so on. Cardhu A01 and A03 are not supported.
> Cardhu A02 and A04 have different sets of GPIO for regualtors.
> The cardhu A04 is compatible for A05, A06 and A07 in GPIOs.
> This patch series split the cardhu dts file to cardhu-a02 and 
> carchu-a04 and then add entry for different fixed regualtors.

Two more comments on this patch, sorry for the noise...

1) With this patch, running "reboot" or "shutdown -r now" no longer
works; the system hangs. Reboot works fine without this patch, in
next-20120708.

2) U-Boot initializes the LCD, and prints to it. This is left running
when the kernel is booted, and the kernel doesn't reprogram the HW, so
the LCD continues to scan out some "random" area of memory. Typically,
this then gets used and so the LCD shows random patterns. In today's
linux-next it seems to be turned black though; not sure why that's
happening. Either way, this patch turns the whole LCD completely white.
Is that an expected change?
