Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030977Ab2CFUPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:15:44 -0500
Received: from smtp13.mail.ru ([94.100.176.90]:42756 "EHLO smtp13.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030933Ab2CFUPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:15:42 -0500
Date: Wed, 7 Mar 2012 00:15:38 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/2] arm/tegra: add timeout to PCIe PLL lock
 detection loop
Message-ID: <20120306201538.GA14350@rainbow>
References: <1331023544-6439-1-git-send-email-mad_soft@inbox.ru>
 <1331023544-6439-3-git-send-email-mad_soft@inbox.ru>
 <4F56424A.3020305@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F56424A.3020305@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:58 Tue 06 Mar     , Stephen Warren wrote:
> On 03/06/2012 01:45 AM, Dmitry Artamonow wrote:
> > Tegra PCIe driver waits for PLL to lock using busy loop.
> > If PLL fails to lock for some reason, this leads to silent lockup
> > while booting (as PCIe code is not modular).
> > 
> > Fix by adding timeout, so if PLL doesn't lock in a couple
> > of seconds, just PCIe driver fails and machine continues to boot.
> > 
> > Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> 
> That seems reasonable. So once the mdelay discussion is resolved,
> 
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> 
> Any idea why the PLL doesn't lock sometimes?


Please dismiss this patch - I forgot to turn 'return' to 'return 0' at
the end of the function, while converting it's type from void to int,
and it causes driver to fail always now. I'll send updated version shortly.

Also I've managed to get another Harmony board today, and it doesn't have
problems with PLL locking (PLL locks on it in about 2ms), so probably the
issue I've seen is caused by some hardware fault on the first board,
or is specific to some particular revision of the board and/or Tegra2 chip.

I'll do more testing tomorrow and re-spin the patches.
-- 
Best regards,
Dmitry "MAD" Artamonow

