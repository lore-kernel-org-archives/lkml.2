Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab0IBWWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 18:22:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42497 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756901Ab0IBWWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 18:22:48 -0400
Date: Thu, 2 Sep 2010 23:41:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Chew <AChew@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH 1/1] iio: ak8975: Add Ak8975 magnetometer sensor
Message-ID: <20100902234124.584b9bf7@lxorguk.ukuu.org.uk>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F763816B85AD096@HQMAIL03.nvidia.com>
References: <1283463351-15816-1-git-send-email-achew@nvidia.com>
	<20100902231942.21375cc0@lxorguk.ukuu.org.uk>
	<643E69AA4436674C8F39DCC2C05F763816B85AD096@HQMAIL03.nvidia.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010 15:16:20 -0700
Andrew Chew <AChew@nvidia.com> wrote:

> > > +static IIO_DEVICE_ATTR(mode, S_IRUGO | S_IWUSR, show_mode, 
> > store_mode, 0);
> > > +static IIO_DEVICE_ATTR(magn_x_calibscale, S_IRUGO, 
> > show_calibscale, NULL, 0);
> > > +static IIO_DEVICE_ATTR(magn_y_calibscale, S_IRUGO, 
> > show_calibscale, NULL, 1);
> > > +static IIO_DEVICE_ATTR(magn_z_calibscale, S_IRUGO, 
> > show_calibscale, NULL, 2);
> > > +static IIO_DEV_ATTR_MAGN_X(show_raw, AK8975_REG_HXL);
> > > +static IIO_DEV_ATTR_MAGN_Y(show_raw, AK8975_REG_HYL);
> > > +static IIO_DEV_ATTR_MAGN_Z(show_raw, AK8975_REG_HZL);
> > 
> > This seems odd as an interface as it's raw when the maths to provide
> > non-raw (and thus abstract and easy for user space) data is trivial
> > enough to do in kernel
> 
> IIO guys want to do normalization maths above the kernel-level magnetometer IIO layer.  This interface came before me, so I'm just following current conventions.

That will make a generic IIO <-> input bridge very hard to do right. I
can see why IIO wants to do that but you need both if so and this also
needs discussion.

