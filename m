Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab2KDRaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 12:30:18 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39249 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab2KDRaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 12:30:15 -0500
Date: Sun, 04 Nov 2012 12:30:13 -0500 (EST)
Message-Id: <20121104.123013.700345271120279281.davem@davemloft.net>
To: lee.jones@linaro.org
Cc: pebolle@tiscali.nl, linux-kernel@vger.kernel.org, isdn@linux-pingi.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH 8/9] isdn: Remove unused variable causing a compile
 build warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121104105332.GC27124@gmail.com>
References: <20121103224832.GA24262@gmail.com>
	<1352024091.1434.17.camel@x61.thuisdomein>
	<20121104105332.GC27124@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA4HUPbV004802

From: Lee Jones <lee.jones@linaro.org>
Date: Sun, 4 Nov 2012 11:53:32 +0100

> On Sun, 04 Nov 2012, Paul Bolle wrote:
> 
>> On Sat, 2012-11-03 at 23:48 +0100, Lee Jones wrote:
>> > On Sat, 03 Nov 2012, Paul Bolle wrote:
>> > > On Sat, 2012-11-03 at 23:02 +0100, Lee Jones wrote:
>> > > > This patch fixes:
>> > > > drivers/isdn/i4l/isdn_common.c: In function ¡isdn_ioctl¢:
>> > > > drivers/isdn/i4l/isdn_common.c:1278:8: warning: unused variable ¡s¢ [-Wunused-variable]
>> > > 
>> > > Did you have CONFIG_NETDEVICES not set in this build?
>> > 
>> > Ah yes, I see it. The function went down further than I thought
>> > it did. So the real fix is to ensure 's' is defined inside of
>> > some ifdef CONFIG_NETDEVICES guards. 
>> 
>> What puzzles me is that we only find these "#ifdef CONFIG_NETDEVICES"
>> guards in this file and not in isdn_net.c, were all the ioctl commands
>> guarded that way seem to be calling into. On first glance that doesn't
>> make much sense.
>> 
>> (Actually the idea of having ISDN without NETDEVICES is a bit puzzling
>> too. But there are too many parts of the isdn subsystem that I'm
>> unfamiliar with to say whether that can make sense.)
> 
> I'm in the same position as you Paul. I just noticed the warning so
> fixed it following the current way of doing things. Any, more
> substantial changes requiring greater knowledge of the subsystem
> would have to be done by someone else.

I think the most appropriate thing to do is make CONFIG_ISDN depend
upon CONFIG_NETDEVICES in the Kconfig file.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
