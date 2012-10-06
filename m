Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2JFTyy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 15:54:54 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:20065 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab2JFTyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 15:54:51 -0400
Date: Sat, 6 Oct 2012 21:54:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        fabien.andre@gmail.com, scott.liu@emc.com.tw,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification 
 implementation
Message-ID: <20121006215416.5fdbb6ef@endymion.delvare>
In-Reply-To: <20121003164306.GA18529@core.coreip.homeip.net>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com>
	<20121003164306.GA18529@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2012 09:43:12 -0700, Dmitry Torokhov wrote:
> On Fri, Sep 14, 2012 at 03:41:43PM +0200, benjamin.tissoires wrote:
> > +	}
> > +
> > +	do {
> > +		ret = i2c_transfer(client->adapter, msg, msg_num);
> > +		if (ret > 0)
> > +			break;
> > +		tries--;
> > +		dev_dbg(&client->dev, "retrying i2chid_command:%d (%d)\n",
> > +			command, tries);
> > +	} while (tries > 0);
> > +
> > +	if (wait && ret > 0) {
> > +		if (debug)
> > +			dev_err(&client->dev, "%s: waiting....\n", __func__);
> > +		if (!wait_event_timeout(ihid->wait,
> > +				!test_bit(I2C_HID_RESET_PENDING, &ihid->flags),
> > +				msecs_to_jiffies(5000)))
> > +			ret = -ENODATA;
> > +		if (debug)
> > +			dev_err(&client->dev, "%s: finished.\n", __func__);
> 
> Why do we have error level messages with debug? I know dev_dbg is
> compiled out if !DEBUG, but there must be a better way. Maybe define
> i2c_hid_dbg() via dev_printk() and also check debug condition there?

dev_dbg() is compiled out if !DEBUG only if CONFIG_DYNAMIC_DEBUG isn't
set. These days I think every developer want to enable this option.

-- 
Jean Delvare
