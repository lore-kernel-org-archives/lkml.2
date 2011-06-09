Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab1FIQaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:30:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54386 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751556Ab1FIQaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:30:06 -0400
Date: Thu, 9 Jun 2011 17:32:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Andersson <eric.andersson@unixphere.com>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengguang.guo@bosch-sensortec.com,
        stefan.nilsson@unixphere.com,
        Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH] input: add driver for Bosch Sensortec's BMA150
 accelerometer
Message-ID: <20110609173203.020d5017@lxorguk.ukuu.org.uk>
In-Reply-To: <20110609161224.GA7098@skinner>
References: <1306857314-655-1-git-send-email-eric.andersson@unixphere.com>
	<20110531172320.0fcadfef@lxorguk.ukuu.org.uk>
	<20110609161224.GA7098@skinner>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > What locks this SMBUS transaction against others
> True! I will look over the locking for the next version.

I have a suspicion the two drivers are distant relatives actually - the
bugs look similar !
> 
> > > +static int bma150_set_range(struct i2c_client *client, unsigned char range)
> > > +{
> > > +	int ret;
> > > +	unsigned char data;
> > > +
> > > +	if (range > BMA150_RANGE_8G)
> > > +		return -EINVAL;
> > 
> > This should be actual values not a register range
> It is an actual value. See chapter 3.1.2 in the BMA150 datasheet where the
> acceleration range values are defined.

It should specify the units and be in meaningful ones not register values
(I got moaned at for that in my submission too!)

> I will send an updated version of the driver once I've fixed it!

Cool - I really don't care btw which driver we end up with a mix of both,
I just need it to work on our platform too.

Dunno where Dmitry has gone - has he vanished ?
