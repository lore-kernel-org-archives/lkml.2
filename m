Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030905Ab2K3Pk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:40:57 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34543 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030746Ab2K3Pkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:40:55 -0500
Message-ID: <1354290055.11903.20.camel@joe-AO722>
Subject: Re: [PATCH 1/1] Input: STMicroelectronics multi touch capacitive
 touchscreen ftk
From: Joe Perches <joe@perches.com>
To: balbi@ti.com
Cc: Li Wu <willy.woo@gmail.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Li Wu <li.wu@st.com>, Henrik Rydberg <rydberg@euromail.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Shawn Landden <shawnlandden@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jianchun <jcbian@pixcir.com.cn>, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, victor.phay@st.com
Date: Fri, 30 Nov 2012 07:40:55 -0800
In-Reply-To: <20121130150437.GE17587@arwen.pp.htv.fi>
References: <1354285134-8188-1-git-send-email-willy.woo@gmail.com>
	 <20121130150437.GE17587@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-30 at 17:04 +0200, Felipe Balbi wrote:
> On Fri, Nov 30, 2012 at 09:18:54AM -0500, Li Wu wrote:
> > This is a initial driver for STMicroelectronics multi touch
> > capacitive touchscren FingertipK. It supports maximum 10 fingers,
> > based on I2C interface.
[]
> diff --git a/drivers/input/touchscreen/ftk.c b/drivers/input/touchscreen/ftk.c
[]
> > +static int stm_ts_probe(struct i2c_client *client,
> > +			const struct i2c_device_id *idp)
> > +{
[]
> > +	ftk_ts->dev = &ftk_ts->client->dev;
> > +	ftk_ts->input_dev = input_allocate_device();

It'd be nicer to use a temporary "dev"

> > +	ftk_ts->input_dev->dev.parent = &client->dev;
> > +	if (!ftk_ts->input_dev) {
> > +		dev_err(ftk_ts->dev, "err = ENOMEM!\n");
> > +		err = ENOMEM;
> > +		goto fail;
> > +	}

Put the dev_parent assign after the error check.

> > +	ftk_ts->input_dev->name = "ftk";
> > +	ftk_ts->input_dev->phys = "ftk/input0";
> > +	ftk_ts->input_dev->id.bustype = BUS_I2C;
> > +	ftk_ts->input_dev->id.vendor = 0x0001;
> > +	ftk_ts->input_dev->id.product = 0x0002;
> > +	ftk_ts->input_dev->id.version = 0x0100;

All of these would be a lot shorter and likely fit on
a single line with just
	dev->name = "ftk";
etc..


