Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2LEKHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:07:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab2LEKHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:07:42 -0500
Date: Wed, 5 Dec 2012 11:07:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/14] HID: i2c-hid: fix error messages
In-Reply-To: <20121205105158.666a19a8@endymion.delvare>
Message-ID: <alpine.LNX.2.00.1212051107290.17055@pobox.suse.cz>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com> <1354634875-5182-9-git-send-email-benjamin.tissoires@gmail.com> <20121205105158.666a19a8@endymion.delvare>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2012, Jean Delvare wrote:

> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> > ---
> >  drivers/hid/i2c-hid/i2c-hid.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> > index d6fdb3e..da04948 100644
> > --- a/drivers/hid/i2c-hid/i2c-hid.c
> > +++ b/drivers/hid/i2c-hid/i2c-hid.c
> > @@ -741,10 +741,10 @@ static int __devinit i2c_hid_init_irq(struct i2c_client *client)
> >  			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> >  			client->name, ihid);
> >  	if (ret < 0) {
> > -		dev_dbg(&client->dev,
> > +		dev_warn(&client->dev,
> >  			"Could not register for %s interrupt, irq = %d,"
> >  			" ret = %d\n",
> > -		client->name, client->irq, ret);
> > +			client->name, client->irq, ret);
> >  
> >  		return ret;
> >  	}
> > @@ -770,7 +770,8 @@ static int __devinit i2c_hid_fetch_hid_descriptor(struct i2c_hid *ihid)
> >  			__func__, 4, ihid->hdesc_buffer);
> >  
> >  	if (ret) {
> > -		dev_err(&client->dev, "HID_DESCR_LENGTH_CMD Fail (ret=%d)\n",
> > +		dev_err(&client->dev,
> > +			"unable to fetch the size of HID descriptor (ret=%d)\n",
> >  			ret);
> >  		return -ENODEV;
> >  	}
> > @@ -785,7 +786,7 @@ static int __devinit i2c_hid_fetch_hid_descriptor(struct i2c_hid *ihid)
> >  	/* check bcdVersion == 1.0 */
> >  	if (le16_to_cpu(hdesc->bcdVersion) != 0x0100) {
> >  		dev_err(&client->dev,
> > -			"unexpected HID descriptor bcdVersion (0x%04x)\n",
> > +			"unexpected HID descriptor bcdVersion (0x%04hx)\n",
> >  			le16_to_cpu(hdesc->bcdVersion));
> >  		return -ENODEV;
> >  	}
> > @@ -871,7 +872,7 @@ static int __devinit i2c_hid_probe(struct i2c_client *client,
> >  	hid->vendor = le16_to_cpu(ihid->hdesc.wVendorID);
> >  	hid->product = le16_to_cpu(ihid->hdesc.wProductID);
> >  
> > -	snprintf(hid->name, sizeof(hid->name), "%s %04X:%04X",
> > +	snprintf(hid->name, sizeof(hid->name), "%s %04hX:%04hX",
> >  		 client->name, hid->vendor, hid->product);
> >  
> >  	ret = hid_add_device(hid);
> 
> Reviewed-by: Jean Delvare <khali@linux-fr.org>

Applied.

-- 
Jiri Kosina
SUSE Labs
