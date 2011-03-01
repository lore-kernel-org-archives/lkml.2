Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab1CATeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:34:08 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:44932 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756816Ab1CATeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:34:05 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Kiran Divekar <dkiran@marvell.com>, Frank Huang <frankh@marvell.com>
Date: Tue, 1 Mar 2011 11:33:55 -0800
Subject: RE: [RFC v2 1/2] dynamic debug: add dynamic_hexdump_debug macro
Thread-Topic: [RFC v2 1/2] dynamic debug: add dynamic_hexdump_debug macro
Thread-Index: AcvX0Rx8d+v69aUBQ+S5mml6FYrx6AAdOprQ
Message-ID: <477F20668A386D41ADCC57781B1F704307F5150529@SC-VEXCH1.marvell.com>
References: <1298956016-30673-1-git-send-email-bzhao@marvell.com>
	 <1298956016-30673-2-git-send-email-bzhao@marvell.com>
 <1298957138.4367.3.camel@Joe-Laptop>
In-Reply-To: <1298957138.4367.3.camel@Joe-Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p21JYFuV015252

Hi Joe,

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Monday, February 28, 2011 9:26 PM
> To: Bing Zhao
> Cc: linux-kernel@vger.kernel.org; linux-wireless@vger.kernel.org; John W. Linville; Johannes Berg;
> Amitkumar Karwar; Kiran Divekar; Frank Huang
> Subject: Re: [RFC v2 1/2] dynamic debug: add dynamic_hexdump_debug macro
> 
> On Mon, 2011-02-28 at 21:06 -0800, Bing Zhao wrote:
> > dynamic_hexdump_debug(str, buf, len)
> 
> > diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> > +#define dynamic_hexdump_debug(str, buf, len)				\
> > +do {									\
> > +	static struct _ddebug descriptor				\
> > +	__used								\
> > +	__attribute__((section("__verbose"), aligned(8))) =		\
> > +	{ KBUILD_MODNAME, __func__, __FILE__, str, __LINE__,		\
> > +		_DPRINTK_FLAGS_DEFAULT };				\
> > +	if (unlikely(descriptor.enabled)) {				\
> > +		printk(KERN_DEBUG str);					\
> > +		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, buf, len);	\
> 
> Perhaps
> 		print_hex_dump(str, DUMP_PREFIX_OFFSET, buf, len);

I wanted to print the "str" as a subject line, like this:

mwifiex data: tx_buf:
00000000: 34 8c 24 a0 ff ff ff ff 36 72 24 a0 ff ff ff ff  4.$.....6r$.....
00000010: d7 7f 24 a0 ff ff ff ff 80 8e 24 a0 ff ff ff ff  ..$.......$.....
00000020: df 7d 24 a0 ff ff                                .}$...

The "str" will serve as the prefix strings if we use
print_hex_dump(KERN_DEBUG, str, DUMP_PREFIX_OFFSET, 16, 1, buf, len, true);

mwifiex data: tx_buf:00000000: 34 8c 24 a0 ff ff ff ff 36 72 24 a0 ff ff ff ff  4.$.....6r$.....
mwifiex data: tx_buf:00000010: d7 7f 24 a0 ff ff ff ff 80 8e 24 a0 ff ff ff ff  ..$.......$.....
mwifiex data: tx_buf:00000020: df 7d 24 a0 ff ff                                .}$...

I'm okay with this format too.

Thanks,

Bing

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
