Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab0INTuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:50:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41476 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab0INTuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:50:19 -0400
Date: Tue, 14 Sep 2010 20:48:06 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Jonathan Cameron <arm@jic23.retrosnub.co.uk>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Joe Perches <joe@perches.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/25] drivers/i2c: Use static const char arrays
Message-ID: <20100914194806.GA26693@n2100.arm.linux.org.uk>
References: <cover.1284406638.git.joe@perches.com> <b0c83cb1b42c6adf38f6322066fb457693f7ac3b.1284406638.git.joe@perches.com> <4C8E84A0.1010606@jic23.retrosnub.co.uk> <19599.9719.562406.692216@ipc1.ka-ro> <4C8F7157.9060005@jic23.retrosnub.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C8F7157.9060005@jic23.retrosnub.co.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 01:57:59PM +0100, Jonathan Cameron wrote:
> On 09/14/10 08:36, Lothar Waßmann wrote:
> > Hi,
> > 
> > Jonathan Cameron writes:
> >>  Commit message is  somewhat inaccurate...
> >>
> >> On 09/13/10 20:47, Joe Perches wrote:
> >>> Signed-off-by: Joe Perches <joe@perches.com>
> >>> ---
> >>>  drivers/i2c/busses/i2c-stu300.c |    4 ++--
> >>>  1 files changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/i2c/busses/i2c-stu300.c b/drivers/i2c/busses/i2c-stu300.c
> >>> index 495be45..2f7c09c 100644
> >>> --- a/drivers/i2c/busses/i2c-stu300.c
> >>> +++ b/drivers/i2c/busses/i2c-stu300.c
> >>> @@ -871,7 +871,7 @@ stu300_probe(struct platform_device *pdev)
> >>>  	struct resource *res;
> >>>  	int bus_nr;
> >>>  	int ret = 0;
> >>> -	char clk_name[] = "I2C0";
> >>> +	char clk_name[sizeof("I2Cx")];
> >>>  
> >>>  	dev = kzalloc(sizeof(struct stu300_dev), GFP_KERNEL);
> >>>  	if (!dev) {
> >>> @@ -881,7 +881,7 @@ stu300_probe(struct platform_device *pdev)
> >>>  	}
> >>>  
> >>>  	bus_nr = pdev->id;
> >>> -	clk_name[3] += (char)bus_nr;
> >>> +	sprintf(clk_name, "I2C%c", '0' + bus_nr);
> >> I'm guessing that there are never more than a couple of these.
> >> Why is this method a better bet than just putting %d?
> >>
> > '%c' will only ever produce one byte of output while '%d' may
> > produce up to 11 bytes depending on the value of bus_nr thus
> > overflowing the buffer.
> Then use an snprintf, or apply a check to ensure it isn't bigger than
> 9.
> 
> If you don't mind having clocks named i2c$ or something equally
> silly then I guess this is fine.  To my mind, if that is possible
> this is a bug that should be fixed rather than avoided.

Even better, fix the implementation so that it conforms to the API
spec rather than doing its own thing with the consumer connection ID
argument and ignoring the struct device argument.
