Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab1GNWhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 18:37:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41693 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932371Ab1GNWho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 18:37:44 -0400
Date: Thu, 14 Jul 2011 23:40:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Andersson <eric.andersson@unixphere.com>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengguang.guo@bosch-sensortec.com,
        stefan.nilsson@unixphere.com,
        Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH v3 1/1] input: add driver for Bosch Sensortec's BMA150
 accelerometer
Message-ID: <20110714234030.30d6b455@lxorguk.ukuu.org.uk>
In-Reply-To: <1310680572-27410-2-git-send-email-eric.andersson@unixphere.com>
References: <1310680572-27410-1-git-send-email-eric.andersson@unixphere.com>
	<1310680572-27410-2-git-send-email-eric.andersson@unixphere.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		values represent the range given as +/- G.
> +		Possible values are: 2, 4, 8.
> +
> +		Reading: returns the current acceleration range.
> +
> +		Writing: sets a new acceleration range.

Same comment as last time - these values are not discoverable so it
should set the nearest bigger range.

> +
> +
> +What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/bandwidth
> +Date:		May 2011
> +Contact:	Eric Andersson <eric.andersson@unixphere.com>
> +Description:	This is used to setup the digital filtering on ADC output data.
> +		The values represent the bandwidth given in Hz.
> +		Possible values are: 25, 50, 100, 190, 375, 750, 1500
> +
> +		Reading: returns the current bandwidth.
> +
> +		Writing: sets a new bandwidth.

Ditto


> +	for (i = 0, ret = 0; i < ARRAY_SIZE(bw_val); i++)
> +		ret += sprintf(buf + ret,
> +			(bw_val[i].reg == bw) ? "[%d] " : "%d ",
> +			bw_val[i].value);

sysfs nodes should really be single values

> +static const struct i2c_device_id bma150_id[] = {
> +	{ "bma150", 0 },
> +	{ "smb380", 0 },

bma023 ?

It also doesn't expose the thresholds or support interrupts which the
one I posted did.

So while its better it still seems incomplete - its certainly nowhere
near where it can replace the one I posted months ago and doesn't seem to
be making any headway.

Dmitry shall I repost the intel one - at this point I think it would be a
better starting point as it supports more features, interrupts and the
like although it's not perfect either.

Alan
