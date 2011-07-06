Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1GFMGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 08:06:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54239 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1GFMGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 08:06:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: Re: [PATCH V2 2/6] arm_smp_twd: mpcore_wdt: Fix watchdog counter loading
Date: Wed, 6 Jul 2011 14:05:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Wim Van Sebroeck <wim@iguana.be>,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@fluxnic.net>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <1309892440-3260-3-git-send-email-vkuzmichev@mvista.com>
In-Reply-To: <1309892440-3260-3-git-send-email-vkuzmichev@mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107061405.44096.arnd@arndb.de>
X-Provags-ID: V02:K0:WaaZ80iYJKaUzHSWVThx+2TbYi9kMHcntPDzRAdGh+z
 C5YcgkpzKizl7Hb3YtdZPmrN6SfZBCkdHdRjJZGbVyJP28Wj15
 4JMCiu+HiCQ9ByfndM0G3SFifom8EHfoTKaU5C0VQXN4pq9W9c
 bYNC2hA1e0G5ZPIV8EiKCDfmbk/RKSnNQZbrywTk/P+2v6pqRE
 K2wbWZ1UlIIuPn6T3B56w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011, Vitaly Kuzmichev wrote:
> +/* Needed by mpcore_wdt */
> +unsigned long twd_timer_get_rate(void)
> +{
> +       unsigned long rate;
> +
> +       if (!IS_ERR_OR_NULL(twd_clk))
> +               rate = clk_get_rate(twd_clk);
> +       else
> +               rate = twd_timer_rate;
> +       return rate;
> +}
> +EXPORT_SYMBOL(twd_timer_get_rate);

I would generally prefer to make new exported symbols EXPORT_SYMBOL_GPL
instead of EXPORT_SYMBOL.

	Arnd
