Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1KZTLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 14:11:53 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:63664 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab1KZTLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 14:11:49 -0500
Date: Sat, 26 Nov 2011 20:11:37 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: lars@metafoo.de
Cc: linux-iio@vger.kernel.org, greg@kroah.com, linux-kernel@vger.kernel.org,
        federico.vaga@gmail.com, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: Re: [RFC PATCH 0/7] Introducing ZIO, a new I/O framework
Message-ID: <20111126191137.GA1046@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <4ED12B50.9090206@metafoo.de>
References: <4ED12B50.9090206@metafoo.de>
  <cover.1322328073.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You've Cc'ed the IIO mailinglist, so you know about the IIO
> framework.

Yes, we are aware of it. Initially we hoped to use it for our
boards. There is an analysis by Federico on the ohwr wiki:

http://www.ohwr.org/projects/zio/wiki/Iio

See especially the final table about how it fits our requirements:

http://www.ohwr.org/projects/zio/wiki/Requirements

> Could you explain why you need a new framework and your devices
> can't be supported by the IIO framework?

Mainly, because the use-cases it is designed for are different.  It
handles data one sample at a time while our data blocks are tens of
hundreds of megabytes; there is still no support for output; data is
expected to be analog only; timestamps are assumed to be nanoseconds.
Also, we need easy off-line elaboration of data, that's why we attach
a control structure to each data block (and user-space can ignore the
control structure and work with data alone, if needed).

ZIO can work with accelerometers (we have one we'll support soon),
but we need to support accelerators too.  I think IIO is much better
than ZIO for accelerometers, thermometers and similar stuff.

> After a first quick glance ZIO looks to me like a subset of IIO.

In some sense, yes. It's only a mechanism for data transfer, insisting
to not attach any meaning to the data it carries around.

I'm open to suggestions (_we_ are) about how to easily use IIO for
output, for hardware timestamps (we have 3 32-bit fields) and for very
large data blocks, with DMA to/from user space -- sure we don't have this
last point in ZIO at this point in time.

Thank you for your interest
/alessandro
