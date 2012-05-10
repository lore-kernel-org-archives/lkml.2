Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386Ab2EJAB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:01:29 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44274 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755914Ab2EJAB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:01:28 -0400
X-Sasl-enc: xCK4/umPSZ+2UuQD8f+z2aBi/CBE3CYwG8DrLR2jbiDZ 1336608087
Date: Wed, 9 May 2012 17:01:26 -0700
From: Greg KH <greg@kroah.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Markus Franke <markus.franke@s2002.tu-chemnitz.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120510000126.GA2357@kroah.com>
References: <20120430021300.GA18148@kroah.com>
 <4FA1953B.40008@hrz.tu-chemnitz.de>
 <20120502202134.GB26628@kroah.com>
 <20120503180056.GB13988@ioremap.net>
 <4FAAD584.70102@hrz.tu-chemnitz.de>
 <20120509220636.GA27659@kroah.com>
 <4FAAECB7.8070904@hrz.tu-chemnitz.de>
 <20120509222411.GA24302@kroah.com>
 <4FAAF1C4.2050500@hrz.tu-chemnitz.de>
 <20120509235723.GA7404@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509235723.GA7404@ioremap.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 03:57:23AM +0400, Evgeniy Polyakov wrote:
> On Thu, May 10, 2012 at 12:37:56AM +0200, Markus Franke (markus.franke@s2002.tu-chemnitz.de) wrote:
> > Well, the data read/written through this file is actually directly
> > "passed" on to the device. There are two bits which reflect the current
> > state of the PIO pins of the DS28E04. However, I must admit that this
> > could also be implemented as regular sysfs attributes.
> 
> Greg, could you please describe what is exactly wrong with binary sysfs
> file? Or am I missing that it is not usual sysfs file but some special
> stuff?

Binary sysfs files should be "pass through" only, the kernel should not
touch the data involved in them at all, it is a pipe directly from the
kernel to userspace for binary blob data, like firmware images.  You
should never do any processing of any binary file data at all in the
kernel.

Hope this helps,

greg k-h
