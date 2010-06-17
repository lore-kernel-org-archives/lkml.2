Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab0FQLRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 07:17:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58956 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751362Ab0FQLRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 07:17:11 -0400
Date: Thu, 17 Jun 2010 12:20:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oneukum@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hmc6352: Add driver for the HMC6352 compass
Message-ID: <20100617122048.142def43@lxorguk.ukuu.org.uk>
In-Reply-To: <201006161443.45375.oneukum@suse.de>
References: <20100616121534.26294.12540.stgit@localhost.localdomain>
	<201006161443.45375.oneukum@suse.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 14:43:45 +0200
Oliver Neukum <oneukum@suse.de> wrote:

> Am Mittwoch, 16. Juni 2010 14:16:14 schrieb Alan Cox:
> > +       msleep(10); /* sending 0x41 cmd we need to wait for 7-10 milli seconds */
> > +       ret = i2c_transfer(client->adapter, msg1, 1);
> > +       if (ret != 1) {
> > +               dev_warn(dev, "i2c read data cmd failed\n");
> > +               return ret;
> > +       }
> > +       ret_val = i2c_data[0];
> > +       ret_val = ((ret_val << 8) | i2c_data[1]);
> 
> Please use the correct macro for this conversion.

Its an array anyway - there isn't as such a 'correct macro' nor does it
need to be using one.
