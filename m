Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935Ab0FQMZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 08:25:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:33314 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab0FQMZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 08:25:46 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] hmc6352: Add driver for the HMC6352 compass
Date: Thu, 17 Jun 2010 14:26:08 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc2-0.1-default+; KDE/4.3.5; x86_64; ; )
Cc: Alan Cox <alan@linux.intel.com>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100616121534.26294.12540.stgit@localhost.localdomain> <201006161443.45375.oneukum@suse.de> <20100617122048.142def43@lxorguk.ukuu.org.uk>
In-Reply-To: <20100617122048.142def43@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006171426.08442.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 17. Juni 2010 13:20:48 schrieb Alan Cox:
> On Wed, 16 Jun 2010 14:43:45 +0200
> Oliver Neukum <oneukum@suse.de> wrote:
> 
> > Am Mittwoch, 16. Juni 2010 14:16:14 schrieb Alan Cox:
> > > +       msleep(10); /* sending 0x41 cmd we need to wait for 7-10 milli seconds */
> > > +       ret = i2c_transfer(client->adapter, msg1, 1);
> > > +       if (ret != 1) {
> > > +               dev_warn(dev, "i2c read data cmd failed\n");
> > > +               return ret;
> > > +       }
> > > +       ret_val = i2c_data[0];
> > > +       ret_val = ((ret_val << 8) | i2c_data[1]);
> > 
> > Please use the correct macro for this conversion.
> 
> Its an array anyway - there isn't as such a 'correct macro' nor does it
> need to be using one.

So why does he use this unstructured data? Do we just hope the compiler
is good enough on big endian architectures?

	Regards
		Oliver
