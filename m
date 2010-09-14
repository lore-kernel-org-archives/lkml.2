Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0INTZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:25:41 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:23485 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab0INTZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:25:40 -0400
X-SpamScore: -10
X-BigFish: VS-10(zz1dbaL98dNzz1202hzz8275dhz2dh2a8h62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <4C8FCC2E.1020107@freescale.com>
Date: Tue, 14 Sep 2010 14:25:34 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/2.0.6-1.fc13 SeaMonkey/2.0.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        kumar.gala@freescale.com, amit.shah@redhat.com
Subject: Re: [PATCH] hvc_console: fix dropping of characters when output byte
 channel is full
References: <1282329921-24394-1-git-send-email-timur@freescale.com>	<20100914121721.c8671ed8.akpm@linux-foundation.org> <20100914204410.71942cdc@lxorguk.ukuu.org.uk>
In-Reply-To: <20100914204410.71942cdc@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Sep 2010 19:25:35.0272 (UTC) FILETIME=[9AD9A280:01CB5442]
X-Reverse-DNS: de01egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Its a printk handler - better to lose the bytes than hang the box. I
> think the current code is probably right.

What do you think about this change:

http://lists.ozlabs.org/pipermail/linuxppc-dev/2009-October/thread.html#76830

This is the original version of my patch.  In it, I simply allow drivers to
return 0 to indicate that they're too busy to accept data.  It works great
on the hvc driver that we have in-house today, but it might break other
drivers that return 0 to indicate error.

-- 
Timur Tabi
Linux kernel developer at Freescale

