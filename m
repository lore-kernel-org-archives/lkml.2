Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab1GGMpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:45:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59965 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716Ab1GGMpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:45:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: Re: [PATCH V3 3/4] ARM: mpcore_wdt: Fix WDIOC_SETOPTIONS handling
Date: Thu, 7 Jul 2011 14:45:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>, Marc Zyngier <marc.zyngier@arm.com>,
        Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org
References: <1310041339-2348-1-git-send-email-vkuzmichev@mvista.com> <1310041396-2461-3-git-send-email-vkuzmichev@mvista.com>
In-Reply-To: <1310041396-2461-3-git-send-email-vkuzmichev@mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107071445.00560.arnd@arndb.de>
X-Provags-ID: V02:K0:qvzomYgD9Y4MkPmNFdUXC9xwbJ1f4cJu2OVUyu2pr2y
 dzqrkYqZV50lSirM4Ekt7B1hG+RA+VIRiY130RS46Y97K5M5pW
 K4NkdOclevFLLMtCQgNKxI5yjDbU/UYKD8WSLlIgd1CLDvkMkV
 ZQmylhxTqT/k8Ddt1qkClDnsCZ0septqEdmlASBPoIKy8GaHLO
 tyWFewYwTkr1kr7xXw4RA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 July 2011, Vitaly Kuzmichev wrote:
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

Acked-by: Arnd Bergmann <arnd@arndb.de>
