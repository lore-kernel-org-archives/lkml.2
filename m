Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab1GGMof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:44:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51954 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab1GGMod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:44:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: Re: [PATCH V3 2/4] ARM: smp_twd: mpcore_wdt: Fix watchdog counter loading
Date: Thu, 7 Jul 2011 14:44:19 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>, Marc Zyngier <marc.zyngier@arm.com>,
        Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Valentine Barshak <vbarshak@mvista.com>
References: <1310041339-2348-1-git-send-email-vkuzmichev@mvista.com> <1310041396-2461-2-git-send-email-vkuzmichev@mvista.com>
In-Reply-To: <1310041396-2461-2-git-send-email-vkuzmichev@mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107071444.19569.arnd@arndb.de>
X-Provags-ID: V02:K0:A57VGaCRZjvbTMPP3+1/ifOA99RLHSPm2NSJJLh9D75
 aTTxg8XBwgPRDFAxaCMwU8V8Ha6XEMFe3UWxo+GGYhaiKYqYea
 linFrvWgM4uqmNYKuXfvlpJKaXwT3i3sKoVAnAbVlctELqpt21
 WbsdBZt0Ieu9EYZhRF3jcpurclNypqJmBtttOq1chA7XelaetQ
 trB9MRKbm2SwcI4IeenOg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 July 2011, Vitaly Kuzmichev wrote:
> Although the commit "98af057092f8f0dabe63c5df08adc2bbfbddb1d2
>  ARM: 6126/1: ARM mpcore_wdt: fix build failure and other fixes"
> resolved long standing mpcore_wdt driver build problems, it
> introduced an error in the relationship between the MPcore watchdog
> timer clock rate and mpcore_margin, "MPcore timer margin in seconds",
> such that watchdog timeouts are now arbitrary rather than the number
> of seconds specified by mpcore_margin.
> 
> This change restores mpcore_wdt_keepalive() to its equivalent
> implementation prior to commit 98af057 such that watchdog timeouts now
> occur as specified by mpcore_margin.
> 
> The variable 'mpcore_timer_rate' which caused that build failure was
> replaced by 'twd_timer_rate'. Adding exported function to obtain
> 'twd_timer_rate' value in mpcore_wdt driver.
> 
> MPCORE_WATCHDOG needed to build 'mpcore_wdt' already depends on
> HAVE_ARM_TWD needed to build 'smp_twd', so from the point of view of
> 'mpcore_wdt' driver the exported function will always exist.
> 
> Signed-off-by: Valentine Barshak <vbarshak@mvista.com>
> Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>

Looks good now,

Acked-by: Arnd Bergmann <arnd@arndb.de>
