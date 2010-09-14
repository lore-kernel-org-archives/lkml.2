Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab0INLrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 07:47:10 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:17829 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab0INLrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 07:47:08 -0400
Date: Tue, 14 Sep 2010 13:46:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH v2 5/7] hwmon: (lm90) Introduce 3rd set of
  upper temperature limits
Message-ID: <20100914134659.5a9e72df@hyperion.delvare>
In-Reply-To: <20100914125137.0928875b@hyperion.delvare>
References: <1284038750-8833-1-git-send-email-guenter.roeck@ericsson.com>
	<1284038750-8833-6-git-send-email-guenter.roeck@ericsson.com>
	<20100914125137.0928875b@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 12:51:37 +0200, Jean Delvare wrote:
> On Thu, 9 Sep 2010 06:25:48 -0700, Guenter Roeck wrote:
> > @@ -818,6 +839,9 @@ static int lm90_detect(struct i2c_client *new_client,
> >  
> >  static void lm90_remove_files(struct i2c_client *client, struct lm90_data *data)
> >  {
> > +	if (data->flags & LM90_HAVE_EMERGENCY)
> > +		sysfs_remove_group(&client->dev.kobj,
> > +				   &lm90_emergency_group);
> >  	if (data->flags & LM90_HAVE_OFFSET)
> >  		device_remove_file(&client->dev,
> >  				   &sensor_dev_attr_temp2_offset.dev_attr);
> 
> But this flag is never set?

Oh, I get it now, it's set in the next patch. That's not OK, each patch
should do something useful in its own right. This suggests that you
have to swap patches 5/7 and 6/7 in the series, first adding a separate
type for the MAX6659, then adding support for the emergency limits.

Or if this is too much work for you, you may decide to merge both
patches (hint: "quilt fold" is quite helpful for this, if you're using
quilt).

-- 
Jean Delvare
