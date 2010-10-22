Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab0JVUDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:03:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57540 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754244Ab0JVUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:03:06 -0400
Date: Fri, 22 Oct 2010 21:01:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isl29020: ambient light sensor
Message-ID: <20101022210132.72389768@lxorguk.ukuu.org.uk>
In-Reply-To: <20101022125130.064710ba.akpm@linux-foundation.org>
References: <20101022124554.19822.58177.stgit@localhost.localdomain>
	<20101022125130.064710ba.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 12:51:30 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 22 Oct 2010 13:46:07 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > From: Kalhan Trisal <kalhan.trisal@intel.com>
> > 
> > The LS driver will read the latest Lux measurement based upon the
> > light brightness and will report the LUX output through sysfs interface.
> > 
> > This hardware isn't quite the same as the ISL29003 so has a different driver.
> > 
> >
> > ...
> >
> > +static ssize_t als_lux_input_data_show(struct device *dev,
> > +			struct device_attribute *attr, char *buf)
> > +{
> > +	struct i2c_client *client = to_i2c_client(dev);
> > +	int ret_val, val;
> > +	unsigned long int lux;
> > +	int temp;
> > +
> > +	pm_runtime_get_sync(dev);
> > +	msleep(100);
> 
> The msleep() is a bit mysterious.  And long!  A little code comment
> explaining why it's here would illuminate things (heh, I kill me).

It takes that long to get a sensible answer from the device after you
power it up and sysfs doesn't keep enough context around to do poll etc.

It may be possible to shorten it if we've not been suspended but there
isn't a sane way I've found to track last suspended time nicely and race
free in the runtime_pm layer.

> Could/should we make the PM code disappear if !CONFIG_PM?  Such as

Looks sensible. Will add to it.

Alan
