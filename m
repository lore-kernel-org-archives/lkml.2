Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1CRQSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:18:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59913 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab1CRQST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:18:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: IIO comments
Date: Fri, 18 Mar 2011 17:18:08 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
References: <201103152215.20059.arnd@arndb.de> <201103181347.15291.arnd@arndb.de> <4D838313.9020804@cam.ac.uk>
In-Reply-To: <4D838313.9020804@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103181718.08502.arnd@arndb.de>
X-Provags-ID: V02:K0:qeynWuUdsnH5H5fB7Jq0LRBsT+1Tca0UoQpmtQh5XjQ
 gWlra01qJzY4klm62pms5gxuQpIbL/3XqKpN8/TJ62p+hAPYvK
 9ghPU8kr7ZxWH+xfwjNcxb5VXuaQsoLGLWx+Yl80jqarAtd8ko
 tmcUGhMU1wJiK0l3CG2oK16/qkuzzu5TTWLSxjX/JSRFhw0Ki4
 Rh48aue54hvpSQ+ngBL4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011, Jonathan Cameron wrote:
> On 03/18/11 12:47, Arnd Bergmann wrote:
> > On Thursday 17 March 2011, Jonathan Cameron wrote:
> >> On 03/17/11 17:51, Arnd Bergmann wrote:
> >>> I don't completely understand the notation. Regarding the various
> >>> {in0, in1, in2, ...} inputs, is there a fundamental difference between
> >>> them? In the code example I gave, a driver would simply list
> >>> a set of inputs of the same type (IIO_CHAN_IN) and let the core
> >>> enumerate them. What does "in0-in1" mean?
> >>
> >> in0-in1 is a differential adc channel. Literally outputs value on
> >> physical pin 1 subtracted from physical pin 2.
> > 
> > Ok, I see. So these would be fairly hard to enumerate, right?
> > Would it be possible to have one attribute with named "diff%d"
> > and another attribute associated with it that describes which
> > channels are compared?
>
> Could do, but what would it gain us?  If the information is available
> to the core, then it can use it give us the explicit naming? As shown
> below we have to handle holes in the enumeration anyway so this isn't
> to much of a problem.

Maybe I was seeing problems that don't exist here. Wouldn't
you need to numeric identifiers to describe a differential
channel?

I guess if it's always in${i}-in${i+1}, it's still not too hard.

> >>> Ok. I truely hope that most hardware has something like this, but
> >>> we can probably work around it as explained above if not.
> >>
> >> Yes. Though do beware. spi and i2c buses for some of these things
> >> can be 'very' slow and often congested on the actual boards. Hence
> >> we sometimes spend a lot of effort to avoid transactions.
> > 
> > Do the transactions require spinning on the CPU, or do they
> > always  work in the background when they are slow?
> If you have a proper controller it's often DMA based. So the issue
> is more congestion on the bus limiting possible sampling rates than
> cpu load. To a certain extent we can just ignore this issue as long
> as we are open to changes to a driver to minimise bus usage if someone
> has a use case that actually requires it for a given device.

Ok.

	Arnd
