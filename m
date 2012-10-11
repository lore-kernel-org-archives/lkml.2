Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab2JKETR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 00:19:17 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:34222 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2JKETP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 00:19:15 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Wed, 10 Oct 2012 20:46:19 -0700
From: Christopher Heiny <Cheiny@synaptics.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>
Subject: RE: [RFC PATCH 03/06] input/rmi4: I2C physical interface
Thread-Topic: [RFC PATCH 03/06] input/rmi4: I2C physical interface
Thread-Index: AQHNo3i6ODEUP5a1OEawG8JridXoBpexKOsAgAJfd1M=
Date: Thu, 11 Oct 2012 04:21:12 +0000
Message-ID: <BFABBC009FBA1C43B207B15FD485ABD922C22C1F@USW-MAIL1.synaptics-inc.local>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
	<1349496603-20775-4-git-send-email-cheiny@synaptics.com>,<CACRpkdY+hK=zbZz6K-ONyAckfpZ-n+TS5c25AxRETVk1M9weQw@mail.gmail.com>
In-Reply-To: <CACRpkdY+hK=zbZz6K-ONyAckfpZ-n+TS5c25AxRETVk1M9weQw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.10.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> On Sat, Oct 6, 2012 at 6:10 AM, Christopher Heiny <cheiny@synaptics.com> wrote:
> > The I2C physical driver is not extensively changed in terms of
> > functionality since the previous patch.  Management of the attention GPIO
> > has been moved to rmi_driver.c (see previous email), and most of the
> > debug related interfaces have been moved from sysfs to debugfs.  Control
> > of the debug features has been moved from compile-time to runtime
> > switches available via debugfs.
> > 
> > The core I2C functionality was previously ACKed by Jean Delvare.  I don't
> > believe that portion of the code has changed much since then, but we'd
> > appreciate a second glance at this.
> 
> The above commit blurb looks more like a changelog than a description
> of the actual patch. Nothing wrong with that but begin by describing
> the patch first.

Good point.  I was describing the patch, but not from the correct point of view. :-)

[snip some items covered in a previous email]

> 
> > +static int setup_debugfs(struct rmi_device *rmi_dev, struct rmi_i2c_data
> > *data); +static void teardown_debugfs(struct rmi_i2c_data *data);
> 
> Why do you need to forward-declare these? Can't you just move them
> up above the functions using them?

Probably.  We'll do that if possible.

> 
> > +struct i2c_debugfs_data {
> > +       bool done;
> 
> Done with what? ... needs some doc.

OK.

> 
> > +       struct rmi_i2c_data *i2c_data;
> > +};
> 
> (...)
> 
> > +static int __devinit rmi_i2c_probe(struct i2c_client *client,
> > +                                 const struct i2c_device_id *id)
> 
> (...)
> 
> > +       rmi_phys = kzalloc(sizeof(struct rmi_phys_device), GFP_KERNEL);
> 
> (...)
> 
> > +       data = kzalloc(sizeof(struct rmi_i2c_data), GFP_KERNEL);
> 
> Can you use devm_kzalloc(&client->dev, ...) for these so you don't
> need to free() them explicitly?

Hmmmmmm.  That looks like a merge regression - I'm pretty sure we implemented devm_kzalloc there.

> 
> (...)
> 
> > +static int __devexit rmi_i2c_remove(struct i2c_client *client)
> > +{
> > +       struct rmi_phys_device *phys = i2c_get_clientdata(client);
> > +       struct rmi_device_platform_data *pd = client->dev.platform_data;
> > +
> > +       /* Can I remove this disable_device */
> > +       /*disable_device(phys); */
> 
> So just delete these two lines then?

Yes.