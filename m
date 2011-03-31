Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab1CaF3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 01:29:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47079
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754038Ab1CaF3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 01:29:10 -0400
Date: Wed, 30 Mar 2011 22:28:32 -0700 (PDT)
Message-Id: <20110330.222832.193698433.davem@davemloft.net>
To: martinez.javier@gmail.com
Cc: bhutchings@solarflare.com, ffainelli@freebox.fr, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: Remove IRQF_SAMPLE_RANDOM flag from
 network drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1301365651-9106-1-git-send-email-martinez.javier@gmail.com>
References: <1301365651-9106-1-git-send-email-martinez.javier@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Tue, 29 Mar 2011 04:27:31 +0200

> The IRQF_SAMPLE_RANDOM flag is marked as deprecated and will be removed.
> 
> Every input point to the kernel's entropy pool have to better document the
> type of entropy source it is.
> 
> drivers/char/random.c now implements a set of interfaces that can be used for
> devices to collect enviromental noise. IRQF_SAMPLE_RANDOM will be replaced
> with these add_*_randomness exported functions.
> 
> Network drivers are not a good source of entropy. They use as a source of
> entropy essentially a remote host. Which means that the source of entropy can
> be potentially controlled by an attacker. Also, with heavy workloads the
> entropy decreases due to less hardware interrupts happening thanks to irq
> mitigation and NAPI.
> 
> If a system relies in its network interface as a entropy source it has a false
> sense of security. Systems that don't have devices whose drivers are good
> sources of entropy, should either use a hardware random number generator or
> feed the kernel's entropy pool from userspace using other sources of entropy
> such as EGD, video_entropyd, timer_entropyd and audio-entropyd.
> 
> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>

Appied to net-next-2.6, thanks!
