Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1JSEeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:34:05 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:44976 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754277Ab1JSEeE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:34:04 -0400
From: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Date: Wed, 19 Oct 2011 06:33:18 +0200
Subject: RE: [PATCH] drivers/leds/leds-lp5521.c: check if reset is successful
Thread-Topic: [PATCH] drivers/leds/leds-lp5521.c: check if reset is
 successful
Thread-Index: AcyN2m0wYRUN1iBKSKyJ0/jC1BSwXAAPaBBg
Message-ID: <C832F8F5D375BD43BFA11E82E0FE9FE00DC2FE2615@EXDCVYMBSTM005.EQ1STM.local>
References: <1318246202-2476-1-git-send-email-srinidhi.kasagar@stericsson.com>
 <20111018141048.1f38b211.akpm@linux-foundation.org>
In-Reply-To: <20111018141048.1f38b211.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Andrew Morton [mailto:akpm00@gmail.com] On Behalf Of Andrew
> Morton
> Sent: Wednesday, October 19, 2011 2:41 AM
> To: Srinidhi KASAGAR
> Cc: rpurdie@rpsys.net; linux-kernel@vger.kernel.org;
> linus.walleij@linaro.org
> Subject: Re: [PATCH] drivers/leds/leds-lp5521.c: check if reset is
> successful
> 
> On Mon, 10 Oct 2011 17:00:02 +0530
> Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com> wrote:
> 
> > make sure that the reset is successful by issuing a dummy
> > read to R channel current register and check its default
> > value. On some platforms, without this dummy read, any
> > further access to {R/G/B}_EXEC will not have any impact.
> >
> > ...
> >
> > @@ -681,6 +685,21 @@ static int __devinit lp5521_probe(struct
> i2c_client *client,
> >  				     * Exact value is not available. 10 - 20ms
> >  				     * appears to be enough for reset.
> >  				     */
> > +
> > +	/*
> > +	 * Make sure that the chip is reset by reading back
> > +	 * r channel current reg. This is a dummy read, otherwise
> > +	 * in some platforms, access to R G B channel program
> > +	 * execution mode to 'Run' in LP5521_REG_ENABLE register
> > +	 * will not have any affect - strange!
> > +	 */
> > +	lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
> > +	if (buf != LP5521_REG_R_CURR_DEFAULT) {
> > +		dev_err(&client->dev, "error in reseting chip\n");
> > +		goto fail2;
> > +	}
> > +	usleep_range(10000, 20000);
> 
> Sorry, but I found that comment very hard to follow.
> 
> Is this version accurate and complete?
> 
> 	/*
> 	 * Make sure that the chip is reset by reading back the r channel
> 	 * current reg. This dummy read is required on some platforms -
> 	 * otherwise further access to the R G B channels in the
> 	 * LP5521_REG_ENABLE register will not have any effect - strange!
> 	 */

That should be ok.

Thanks Andrew.

Srinidhi
