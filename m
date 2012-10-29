Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761245Ab2J2WMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:12:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38271 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933469Ab2J2WMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 18:12:25 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Input: introduce managed input devices (add devres support)
Date: Mon, 29 Oct 2012 15:12:20 -0700
Message-ID: <8202410.zO713iQhxO@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.9.2 (Linux/3.6.0+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121029213254.GA15390@polaris.bitmath.org>
References: <20121023053513.GA15642@core.coreip.homeip.net> <20121029204023.GB13256@core.coreip.homeip.net> <20121029213254.GA15390@polaris.bitmath.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 29, 2012 10:32:54 PM Henrik Rydberg wrote:
> > > Either way, the code looks functional to me.
> > 
> > So is that "reviewed-by"?
> 
> I was thinking about this hunk:
> > @@ -1972,7 +2084,20 @@ int input_register_device(struct input_dev *dev)
> > 
> >         mutex_unlock(&input_mutex);
> > 
> > +       if (dev->devres_managed) {
> > +               dev_info(dev->dev.parent, "%s: registerign %s with
> > devres.\n", +                       __func__, dev->name ?: "N/A");
> > +               devres_add(dev->dev.parent, devres);
> > +       }
> > 
> >         return 0;
> > 
> > +
> > +err_device_del:
> > +       device_del(&dev->dev);
> > +err_free_vals:
> > +       kfree(dev->vals);
> 
> Won't this yield a double free once we reach release()?

Nicely spotted, we need "dev->vals = NULL;" here.

-- 
Dmitry
