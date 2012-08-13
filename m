Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab2HMJGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 05:06:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab2HMJGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 05:06:49 -0400
Date: Mon, 13 Aug 2012 11:06:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Yann Cantin <yann.cantin@laposte.net>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v2 3/3] input: misc: New USB eBeam input
 driver.
In-Reply-To: <501BEEA8.4060702@laposte.net>
Message-ID: <alpine.LNX.2.00.1208131106040.29827@pobox.suse.cz>
References: <1343912397-18353-1-git-send-email-yann.cantin@laposte.net> <1343912397-18353-4-git-send-email-yann.cantin@laposte.net> <alpine.LRH.2.00.1208031424250.15211@twin.jikos.cz> <501BEEA8.4060702@laposte.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2012, Yann Cantin wrote:

> >> +#include <linux/hid.h>
> > 
> > As this driver is not a HID bus driver, why do you need this include?
> 
> Cinder, removed
> 
> >> +#define DRIVER_VERSION	"v0.7"
> > 
> > I don't think we need to be tracking driver versions for newly submitted 
> > drivers, git is much better at tracking changes.
> 
> Old habit, removed.
> 
> >> +	u16			 X, Y;		/* raw coordinates	     */
> >> +	int			 x, y;		/* computed coordinates      */
> > 
> > X,x being different fields seems confusing to me. How about, let's say, x, 
> > raw_x?
> 
> Done.
>  
> >> +DEVICE_H_ATTR(1);
> >> +DEVICE_H_ATTR(2);
> >> +DEVICE_H_ATTR(3);
> >> +DEVICE_H_ATTR(4);
> >> +DEVICE_H_ATTR(5);
> >> +DEVICE_H_ATTR(6);
> >> +DEVICE_H_ATTR(7);
> >> +DEVICE_H_ATTR(8);
> >> +DEVICE_H_ATTR(9);
> > 
> > You are adding a number of sysfs files. If they are really necessary, 
> > you'll probably need to document those in Documentation/ABI.
> 
> Will do, in testing i suppose.
> 
> BTW : The driver need lot of parameters to be passed from user-space calibration
> tool. The best way to do it isn't decided yet : one sysfs file per parameter, or
> one sysfs file for all, with a big sscanf parsing. Any idea ?

Sysfs always had a rule one value per file, so please stick to that.

> >> +		strlcat(ebeam->name, ")", sizeof(ebeam->name));
> > 
> > I'd suggest checking the length, making sure that you don't overflow the 
> > ->name buffer.
> 
> Something like this ? :
> 
> if (strlcat(ebeam->name, ")", sizeof(ebeam->name))>=sizeof(ebeam->name)) {
> 	// overflowed, closing ) anyway
> 	ebeam->name[sizeof(ebeam->name)-2] = ')';

Some variation on that, yes.

Thanks,

-- 
Jiri Kosina
SUSE Labs
