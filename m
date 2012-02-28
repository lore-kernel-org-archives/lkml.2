Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab2B1DRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 22:17:10 -0500
Received: from mx2.parallels.com ([64.131.90.16]:53021 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab2B1DRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 22:17:07 -0500
From: James Bottomley <jbottomley@parallels.com>
To: Mike Frysinger <vapier@gentoo.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "kyle@mcmartin.ca" <kyle@mcmartin.ca>, "deller@gmx.de" <deller@gmx.de>,
        "dave.anglin@bell.net" <dave.anglin@bell.net>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH v2] parisc: dont unconditionally override CROSS_COMPILE
 for 64 bit.
Thread-Topic: [PATCH v2] parisc: dont unconditionally override CROSS_COMPILE
 for 64 bit.
Thread-Index: AQHM9ZLLA74ijEZElUmnORY0ttBzN5ZRy/kAgAAGK4CAADLGAIAAJOsA
Date: Tue, 28 Feb 2012 03:17:01 +0000
Message-ID: <1330399020.2822.106.camel@dabdike.int.hansenpartnership.com>
References: <1330298813-17262-1-git-send-email-paul.gortmaker@windriver.com>
	 <1330378864.2822.92.camel@dabdike.int.hansenpartnership.com>
	 <1330380189.2822.95.camel@dabdike.int.hansenpartnership.com>
	 <201202272004.55187.vapier@gentoo.org>
In-Reply-To: <201202272004.55187.vapier@gentoo.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.243.235.53]
Content-Type: text/plain; charset="utf-8"
Content-ID: <407E606600900B499DDE6838030C21F5@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1S3Hhs4024060

On Mon, 2012-02-27 at 20:04 -0500, Mike Frysinger wrote:
> On Monday 27 February 2012 17:03:10 James Bottomley wrote:
> > --- a/arch/parisc/Makefile
> > +++ b/arch/parisc/Makefile
> > 
> > -CROSS_COMPILE	:= hppa64-linux-gnu-
> > +
> > +# if no default set, try to find the corresponding 64 bit compiler
> > +ifeq ($(CROSS_COMPILE),)
> > +CROSS_COMPILE	:= $(shell $(CC) -dumpmachine | sed s/hppa-\\\(.*\\\)/hppa64-\\1-/)
> > +endif
> 
> fails when using "hppa2.0-xxx".  perhaps:
> CROSS_COMPILE ?= $(shell $(CC) -dumpmachine | sed 's/^hppa[^-]*-/hppa64-/')
> 
> don't even need the ifeq check then

How is that different from Carlos' suggestion?  The reason it doesn't
work is the same ... CROSS_COMPILE is defined to be empty.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
