Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651Ab0KOT3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:29:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60503
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933579Ab0KOT3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:29:41 -0500
Date: Mon, 15 Nov 2010 11:30:05 -0800 (PST)
Message-Id: <20101115.113005.71581078.davem@davemloft.net>
To: apw@canonical.com
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tim.gardner@canonical.com
Subject: Re: [PATCH 1/1] net: rtnetlink.h -- only include linux/netdevice.h
 when used by the kernel
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289836919-19153-2-git-send-email-apw@canonical.com>
References: <1289836919-19153-1-git-send-email-apw@canonical.com>
	<1289836919-19153-2-git-send-email-apw@canonical.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAFJTqhu025533

From: Andy Whitcroft <apw@canonical.com>
Date: Mon, 15 Nov 2010 16:01:59 +0000

> The commit below added a new helper dev_ingress_queue to cleanly obtain the
> ingress queue pointer.  This necessitated including 'linux/netdevice.h':
 ...
> However this include triggers issues for applications in userspace
> which use the rtnetlink interfaces.  Commonly this requires they include
> 'net/if.h' and 'linux/rtnetlink.h' leading to a compiler error as below:
> 
>   In file included from /usr/include/linux/netdevice.h:28:0,
>                    from /usr/include/linux/rtnetlink.h:9,
>                    from t.c:2:
>   /usr/include/linux/if.h:135:8: error: redefinition of ¡struct ifmap¢
>   /usr/include/net/if.h:112:8: note: originally defined here
>   /usr/include/linux/if.h:169:8: error: redefinition of ¡struct ifreq¢
>   /usr/include/net/if.h:127:8: note: originally defined here
>   /usr/include/linux/if.h:218:8: error: redefinition of ¡struct ifconf¢
>   /usr/include/net/if.h:177:8: note: originally defined here
> 
> The new helper is only defined for the kernel and protected by __KERNEL__
> therefore we can simply pull the include down into the same protected
> section.
> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>

Applied, thanks Andy.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
