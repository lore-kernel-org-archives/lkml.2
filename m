Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301Ab1CDJDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:03:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45242
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571Ab1CDJDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:03:51 -0500
Date: Fri, 04 Mar 2011 01:04:28 -0800 (PST)
Message-Id: <20110304.010428.71127798.davem@davemloft.net>
To: sledz@dresearch.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, m.schuknecht@dresearch.de
Subject: Re: [PATCH resent] tcp: ioctl type SIOCOUTQNSD returns amount of
 data not sent
From: David Miller <davem@davemloft.net>
In-Reply-To: <1299228497-21246-1-git-send-email-sledz@dresearch.de>
References: <1299228497-21246-1-git-send-email-sledz@dresearch.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steffen Sledz <sledz@dresearch.de>
Date: Fri,  4 Mar 2011 09:48:17 +0100

> diff --git a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
> index 199975f..ef2be0b 100644
> --- a/include/asm-generic/ioctls.h
> +++ b/include/asm-generic/ioctls.h
> @@ -74,6 +74,7 @@
>  #define TCSETXW		0x5435
>  #define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
>  #define TIOCVHANGUP	0x5437
> +#define TIOCOUTQNSD	0x5438
>  
>  #define FIONCLEX	0x5450
>  #define FIOCLEX		0x5451

Hitting only asm-generic/ioctls.h is insufficient, many architectures do
not make use of this file and the build will fail for them with your patch
applied.
