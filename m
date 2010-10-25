Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0JYOXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:23:33 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:39916 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab0JYOXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:23:32 -0400
Subject: Re: [PATCH] drivers: rtl818x: request DMA-able memory
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Serafeim Zanikolas <sez@debian.org>, herton@mandriva.com.br,
        linville@tuxdriver.com, joe@perches.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4CC5900A.2050209@users.sourceforge.net>
References: <1287952327-9924-1-git-send-email-sez@debian.org>
	 <4CC5851D.1040204@lwfinger.net>  <4CC5900A.2050209@users.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 16:23:04 +0200
Message-ID: <1288016584.3716.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 15:11 +0100, Hin-Tak Leung wrote:

> >> Despite the indicated intention in comment, the kmalloc() call was not
> >> explicitly requesting memory from ZONE_DMA.

> I had a quick look for similiar constructs and AFAIK only the b43/b43legacy 
> drivers uses DMA buffers. Seems to be a rare practice. Is that something we 
> should or should not do?

I think there's some confusion here about ZONE_DMA vs. DMA-able memory.
All memory you get with kmalloc can be used for DMA, GFP_DMA means using
ZONE_DMA which is a hack for ISA (and in b43 maybe PCMCIA/Cardbus)
devices to put memory into something they can address. I don't think the
latter is necessary for USB devices.

johannes

