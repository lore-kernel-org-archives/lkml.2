Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab0IOOet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:34:49 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:35200 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab0IOOes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:34:48 -0400
Date: Wed, 15 Sep 2010 16:34:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] hwmon: (lm90) Add support for max6695 and 
 max6696
Message-ID: <20100915163407.47e8de54@hyperion.delvare>
In-Reply-To: <20100915142927.GB9707@ericsson.com>
References: <1284038750-8833-1-git-send-email-guenter.roeck@ericsson.com>
	<1284038750-8833-8-git-send-email-guenter.roeck@ericsson.com>
	<20100915132029.4c708c7d@hyperion.delvare>
	<20100915142927.GB9707@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 07:29:27 -0700, Guenter Roeck wrote:
> On Wed, Sep 15, 2010 at 07:20:29AM -0400, Jean Delvare wrote:
> > Would it be possible to simply place these functions at the right
> > location so that forward declarations are not needed? Ideally I would
> > like to get rid of all these forward declarations.
> > 
> I moved lm90_select_remote_channel() so the lm90_read_reg() declaration
> is no longer needed.
> 
> Code structure is such that sensor show/set functions come first, followed by
> "real" code. Unfortunately, that implies that local functions called from
> those functions have to be forward declarated.
> 
> We can move that around to avoid forward declarations, but I would prefer
> to do that in a separate patch if we decide to go that way.

Sure, fine with me.

> [...]
> > > +/*
> > > + * Additional attributes for devices with 3 temperature sensors
> > > + */
> > > +static SENSOR_DEVICE_ATTR_2(temp3_input, S_IRUGO, show_temp11, NULL, 0, 5);
> > > +static SENSOR_DEVICE_ATTR_2(temp3_min, S_IWUSR | S_IRUGO, show_temp11,
> > > +     set_temp11, 3, 6);
> > > +static SENSOR_DEVICE_ATTR_2(temp3_max, S_IWUSR | S_IRUGO, show_temp11,
> > > +     set_temp11, 4, 7);
> > > +static SENSOR_DEVICE_ATTR(temp3_crit, S_IWUSR | S_IRUGO, show_temp8,
> > > +     set_temp8, 6);
> > > +static SENSOR_DEVICE_ATTR(temp3_crit_hyst, S_IRUGO, show_temphyst, NULL, 4);
> > 
> > 4, really? Remote 2 critical limit is 6.
> > 
> I am impressed. Good catch.

Now you understand why it takes me so long to review patches. I
actually read them ;)

-- 
Jean Delvare
