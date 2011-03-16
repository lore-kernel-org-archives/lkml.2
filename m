Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab1CPSwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:52:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63540 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab1CPSwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:52:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: IIO comments
Date: Wed, 16 Mar 2011 19:52:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
References: <201103152215.20059.arnd@arndb.de> <4D80A5B5.2020805@cam.ac.uk> <4D80EB5F.6030805@cam.ac.uk>
In-Reply-To: <4D80EB5F.6030805@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103161952.07486.arnd@arndb.de>
X-Provags-ID: V02:K0:7AsaRpgLxJy4S9ADap/kPbdNpAD0ZP87O4NE3etq4XO
 rBuQEAFgXcGzCVTkAmKbZUQFkFJDAlZXwQ49fnAnVurjKKf6VU
 MzUSlco9zDhlF3XK1fqgw3Ke486h6SBX+HZcaRsNgqmGhInJzF
 TTRgQFNnz5+5Hlvgp/ofeO23VYQGpDQ0aMPi9xCJy6eHqtS9dz
 8rnXBXjAtDIWLXGg/vnJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 March 2011 17:54:55 Jonathan Cameron wrote:
> >> * iio_allocate_device() could get a size argument and
> >> allocate the dev_data together with the iio_dev in 
> >> a single allocation, like netdev_alloc does. In addition,
> >> you can pass a structure with all constant data, such
> >> as THIS_MODULE, and the operations and/or attribute groups,
> >> instead of having to set them individually for each dev.
> > Good idea.
>
> There is an issue here I'd forgotten.  Some of our structures have a
> elements which are cacheline aligned.  For first version of this I'll
> set our alignment requirements as L1_CACHE_BYTES.  Would be nice to be
> able to relax that down the line though as it means we use at least two
> cachelines even if we don't care about that alignment requirement.

I think the data used by a device structure is not really an issue,
especially extending it by just another cache line.

	Arnd
