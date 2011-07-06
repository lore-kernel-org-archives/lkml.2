Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1GFMWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 08:22:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53276 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1GFMWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 08:22:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: Re: [PATCH V2 3/6] mpcore_wdt: Fix WDIOC_SETOPTIONS handling
Date: Wed, 6 Jul 2011 14:22:38 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Wim Van Sebroeck <wim@iguana.be>,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@fluxnic.net>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <1309892440-3260-4-git-send-email-vkuzmichev@mvista.com>
In-Reply-To: <1309892440-3260-4-git-send-email-vkuzmichev@mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107061422.38705.arnd@arndb.de>
X-Provags-ID: V02:K0:BD/D/9w/Vbb1BPs3dQUaPXKRDVSw71j7Rd/6lwxrSCS
 /3lMSAuIZ6sxHahfrSDnd1fUzanz+iR0z8Cb3jXIeLTsoUO/dO
 zr0eqsZeOP+2xdyETGvdRkNdmvqxj7MFpaGdMgPFMvX3Cot/uT
 ZjPidR8+KX467v/Uosvq4+x0/hIbn6J5WC0JNUN2ZG8swFCddm
 /16D9LCqFhYSYu0AdZ5WA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011, Vitaly Kuzmichev wrote:
> 
> According to the include/linux/watchdog.h WDIOC_SETOPTIONS is
> classified as 'read from device' ioctl call:
>   #define WDIOC_SETOPTIONS        _IOR(WATCHDOG_IOCTL_BASE, 4, int)
> 
> However, the driver 'mpcore_wdt' performs 'copy_from_user' only if
> _IOC_WRITE is set, thus the local variable 'uarg' which is used in
> WDIOC_SETOPTIONS handling remains uninitialized.
> 
> The proper way to fix this is to bind WDIOC_SETOPTIONS to _IOW,
> but this will break compatibility.
> So adding additional condition for performing 'copy_from_user'.
> 
> Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>

Is the new watchdog driver core ready for 3.1? If so, the best
solution would be to get rid of the entire ioctl function in
the mpcore_wdt driver and just use the core for that.

Otherwise, this patch is probably the best solution in the meantime.

	Arnd
