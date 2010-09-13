Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab0IMUQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:16:10 -0400
Received: from mail.perches.com ([173.55.12.10]:1944 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603Ab0IMUQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:16:08 -0400
Subject: Re: [PATCH 05/25] drivers/i2c: Use static const char arrays
From: Joe Perches <joe@perches.com>
To: Jonathan Cameron <arm@jic23.retrosnub.co.uk>
Cc: linux-kernel@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        linux-i2c@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4C8E84A0.1010606@jic23.retrosnub.co.uk>
References: <cover.1284406638.git.joe@perches.com>
	 <b0c83cb1b42c6adf38f6322066fb457693f7ac3b.1284406638.git.joe@perches.com>
	 <4C8E84A0.1010606@jic23.retrosnub.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 13:16:07 -0700
Message-ID: <1284408967.26719.36.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 21:08 +0100, Jonathan Cameron wrote:
> Commit message is  somewhat inaccurate...

Yeah, sorry 'bout that.
That's what I get for using a script.
I did write an intro with more complete description.

> > diff --git a/drivers/i2c/busses/i2c-stu300.c b/drivers/i2c/busses/i2c-stu300.c
> > @@ -881,7 +881,7 @@ stu300_probe(struct platform_device *pdev)
> >  	}
> >  
> >  	bus_nr = pdev->id;
> > -	clk_name[3] += (char)bus_nr;
> > +	sprintf(clk_name, "I2C%c", '0' + bus_nr);
> I'm guessing that there are never more than a couple of these.
> Why is this method a better bet than just putting %d?

It tries to standardize the style use and it avoids possible
future checkpatch warnings of:
	char foo[] = "bar"
char array could possibly be static const.

There was another use with "%1.1d" somewhere.

The end result is the same, so I don't really care much
if this sort of change is applied or not.  The possible
checkpatch message could just be considered noise but
Mike Frysinger seemed to prefer it, so I thought I could
try to accommodate him.

cheers, Joe

