Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab0INHhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:37:51 -0400
Received: from mail.karo-electronics.de ([213.146.116.110]:50295 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab0INHht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:37:49 -0400
Message-ID: <19599.9719.562406.692216@ipc1.ka-ro>
Date: Tue, 14 Sep 2010 09:36:23 +0200
From: =?iso-8859-15?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
To: Jonathan Cameron <arm@jic23.retrosnub.co.uk>
Cc: Joe Perches <joe@perches.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        "Jean Delvare \(PC drivers\, core\)" <khali@linux-fr.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 05/25] drivers/i2c: Use static const char arrays
In-Reply-To: <4C8E84A0.1010606@jic23.retrosnub.co.uk>
References: <cover.1284406638.git.joe@perches.com>
	<b0c83cb1b42c6adf38f6322066fb457693f7ac3b.1284406638.git.joe@perches.com>
	<4C8E84A0.1010606@jic23.retrosnub.co.uk>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jonathan Cameron writes:
>  Commit message is  somewhat inaccurate...
> 
> On 09/13/10 20:47, Joe Perches wrote:
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  drivers/i2c/busses/i2c-stu300.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/i2c/busses/i2c-stu300.c b/drivers/i2c/busses/i2c-stu300.c
> > index 495be45..2f7c09c 100644
> > --- a/drivers/i2c/busses/i2c-stu300.c
> > +++ b/drivers/i2c/busses/i2c-stu300.c
> > @@ -871,7 +871,7 @@ stu300_probe(struct platform_device *pdev)
> >  	struct resource *res;
> >  	int bus_nr;
> >  	int ret = 0;
> > -	char clk_name[] = "I2C0";
> > +	char clk_name[sizeof("I2Cx")];
> >  
> >  	dev = kzalloc(sizeof(struct stu300_dev), GFP_KERNEL);
> >  	if (!dev) {
> > @@ -881,7 +881,7 @@ stu300_probe(struct platform_device *pdev)
> >  	}
> >  
> >  	bus_nr = pdev->id;
> > -	clk_name[3] += (char)bus_nr;
> > +	sprintf(clk_name, "I2C%c", '0' + bus_nr);
> I'm guessing that there are never more than a couple of these.
> Why is this method a better bet than just putting %d?
>
'%c' will only ever produce one byte of output while '%d' may
produce up to 11 bytes depending on the value of bus_nr thus
overflowing the buffer.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
