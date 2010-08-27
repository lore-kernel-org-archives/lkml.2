Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0H0NvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:51:08 -0400
Received: from imr4.ericy.com ([198.24.6.8]:51118 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab0H0NvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:51:05 -0400
Date: Fri, 27 Aug 2010 06:49:26 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: Fix checkpatch errors in lm90 driver
Message-ID: <20100827134926.GA21827@ericsson.com>
References: <1282838076-7175-1-git-send-email-guenter.roeck@ericsson.com>
 <20100827134523.6bcc70aa@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100827134523.6bcc70aa@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 07:45:23AM -0400, Jean Delvare wrote:
> Hi Guenter,
> 
> On Thu, 26 Aug 2010 08:54:36 -0700, Guenter Roeck wrote:
> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > ---
> > The main rationale for this cleanup is to prepare the driver for adding max6696
> > support.
> 
> I'm fine with mostly anything, except...
> 
[...]
> >  	/* detection and identification */
> > -	if ((man_id = i2c_smbus_read_byte_data(new_client,
> > -						LM90_REG_R_MAN_ID)) < 0
> > -	 || (chip_id = i2c_smbus_read_byte_data(new_client,
> > -						LM90_REG_R_CHIP_ID)) < 0
> > -	 || (reg_config1 = i2c_smbus_read_byte_data(new_client,
> > -						LM90_REG_R_CONFIG1)) < 0
> > -	 || (reg_convrate = i2c_smbus_read_byte_data(new_client,
> > -						LM90_REG_R_CONVRATE)) < 0)
> > +	man_id = i2c_smbus_read_byte_data(new_client, LM90_REG_R_MAN_ID);
> > +	if (man_id < 0)
> > +		return -ENODEV;
> > +
> > +	chip_id = i2c_smbus_read_byte_data(new_client, LM90_REG_R_CHIP_ID);
> > +	if (chip_id < 0)
> > +		return -ENODEV;
> > +
> > +	reg_config1 = i2c_smbus_read_byte_data(new_client, LM90_REG_R_CONFIG1);
> > +	if (reg_config1 < 0)
> > +		return -ENODEV;
> > +
> > +	reg_convrate = i2c_smbus_read_byte_data(new_client,
> > +						LM90_REG_R_CONVRATE);
> > +	if (reg_convrate < 0)
> >  		return -ENODEV;
> 
> ... this. I think this check should be relaxed a bit, cascaded error
> checking is done in many drivers and I don't think this is anything to
> worry about.
> 
I agree. I struggled with that myself when I made the changes, but let checkpatch win.

> No need to resend, I've just dropped the two chunks I don't like, and
> applied the resulting patch. Thanks!
> 
Great, thanks. 

Next question: lm90_update_device() currently does not return any errors.
In recent drivers, we pass i2c read errors up to userland. Before I introduce
the max6696 changes, does it make sense to add error checking/return
into the driver, similar to what I have done in the smm665 and jc42 drivers ?

Guenter

