Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab1FTUQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:16:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47889 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751808Ab1FTUQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:16:22 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19Q+M9kg3JQ2GuJkdhUUwvWufOY2b6ukQqR3pIqsO
	XfCsZ/P8FaBqt+
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/2 v2] mfd/ab3550: Convert to kstrtou8_from_user
Date: Mon, 20 Jun 2011 22:16:19 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38.8; KDE/4.4.5; x86_64; ; )
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <BANLkTikKRVP4PW48YtR+mMMNsaxTDxoGtw@mail.gmail.com> <1308599189-28555-1-git-send-email-peterhuewe@gmx.de> <20110620195037.GA2534@p183.telecom.by>
In-Reply-To: <20110620195037.GA2534@p183.telecom.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106202216.20343.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 20 Juni 2011, 21:50:38 schrieb Alexey Dobriyan:
> On Mon, Jun 20, 2011 at 09:46:28PM +0200, Peter Huewe wrote:
> > -	char buf[32];
> > -	int buf_size;
> > -	unsigned long user_address;
> > +	u8 user_address;

> > +	/* Get userspace string and convert to number */
> > +	err = kstrtou8_from_user(user_buf, count, 0, &user_address);
...
> > 
> >  	ab->debug_address = user_address;

> 
> You don't need temporary variable and should write straight to final
> location, because kstrto* functions will never write to result unless it
> was converted successfully.

Alexey thank you very much for your review, hints and most of all patience ;)
The code really gets cleaner and cleaner.

While changing the code (once again ;) and looking at your remarks I also saw 
that ab3550->debug_address and ->debug_bank are always casted to u8.

Do you think I could also change the two fields of the struct ab3550 (only 
used in this file) to u8 in this patch, too?
This way I could get rid of the u8* cast which is now needed in this case, if 
I take you last remark into account.
> err = kstrtou8_from_user(user_buf, count, 0, (u8 *)&ab->debug_address);

And also clean the code from all the other unnecessary u8 casts.

What do you think?
Or split it up into two seperate patches?

Thanks,
Peter
