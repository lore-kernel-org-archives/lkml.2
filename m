Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab1IAIoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 04:44:39 -0400
Received: from ra.se.axis.com ([195.60.68.13]:36242 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756447Ab1IAIog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 04:44:36 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Sep 2011 04:44:36 EDT
From: Mikael Starvik <mikael.starvik@axis.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: WANG Cong <xiyou.wangcong@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Jesper Nilsson <jespern@axis.com>, Alan Cox <alan@linux.intel.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Date: Thu, 1 Sep 2011 10:34:28 +0200
Subject: RE: [PATCH] cris: lower the printk level in cris serial driver
Thread-Topic: [PATCH] cris: lower the printk level in cris serial driver
Thread-Index: AcxogMxHOH3/CkbtSqi1Rf8J4+WUqQAAPuGw
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D055C652CFE5D@xmail3.se.axis.com>
References: <1314857640-6623-1-git-send-email-xiyou.wangcong@gmail.com>
	<CAMuHMdWSm2bQQpdM1OM=6+17CeNikn9RYm_BpFmEV7jD4sAPig@mail.gmail.com>
 <20110901090930.064c2775@lxorguk.ukuu.org.uk>
In-Reply-To: <20110901090930.064c2775@lxorguk.ukuu.org.uk>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p818ipDB006075

As a side note crisv10 is old stuff. If you want to change anything keep it simple (like changing log level). Finding someone to verify more correct modifications as Alan proposes may be difficult.

/Mikael

-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: den 1 september 2011 10:10
To: Geert Uytterhoeven
Cc: WANG Cong; linux-kernel@vger.kernel.org; akpm@linux-foundation.org; Mikael Starvik; Jesper Nilsson; Alan Cox; linux-cris-kernel; linux-serial@vger.kernel.org
Subject: Re: [PATCH] cris: lower the printk level in cris serial driver

> > Â  Â  Â  Â if (info->recv_cnt + recvl > 65536) {
> > - Â  Â  Â  Â  Â  Â  Â  printk(KERN_CRIT
> > + Â  Â  Â  Â  Â  Â  Â  printk(KERN_INFO
> > Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  "%s: Too much pending incoming serial data! Dropping %u bytes.\n", __func__, recvl);
> > Â  Â  Â  Â  Â  Â  Â  Â return 0;
> > Â  Â  Â  Â }
> 
> I think dropped data warrants KERN_WARN.

If you have an overflow you want to push the relevant tty flag into the
queue. I'm not sure a printk is that useful - end users of embedded
devices (or even PC desktops) won't see it anyway and if you have serial
console it can actually make things worse

Plus of course it's not rate limited here so its a log wiping vector ...
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
