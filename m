Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2BBKmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:42:14 -0500
Received: from ns.pmeerw.net ([87.118.82.44]:33282 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429Ab2BBKmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:42:12 -0500
Date: Thu, 2 Feb 2012 11:42:09 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, lars@metafoo.de, rpurdie@rpsys.net
Subject: Re: [PATCH v2] add LED driver for PCA9663 I2C chip
In-Reply-To: <20120130163424.ef8eb9af.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.01.1202021130070.10172@pmeerw.net>
References: <1326916289-19004-1-git-send-email-pmeerw@pmeerw.net> <20120130162849.635c83a9.akpm@linux-foundation.org> <20120130163424.ef8eb9af.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Andrew Morton <akpm@linux-foundation.org> wrote:
> > > +exit:
> > > +	while (i--) {
> > > +		led_classdev_unregister(&pca9633[i].led_cdev);
> > > +		cancel_work_sync(&pca9633[i].work);
> > > +	}
> > This (untested!) loop has an off-by-one error. 

> Well, it's partly wrong.  It's wrong for the cancel_work_sync() but not
> for the led_classdev_unregister().  The cancel_work_sync() can just be
> removed: we haven't scheduled any works yet.

there are 4 leds with get led_classdev_register()ed

wouldn't it be possible that someone is starting to use led1 while led3 has 
not been registered yet? if registration for led3 fails, the exit code 
(above) is called and there might be work scheduled

so (hypothetically):
register led1 -> ok
register led2 -> ok
use led1 (schedule work)
register led3 -> fail -> exit code

the code has been copied from other led drivers
I think there is no harm to keep cancel_work_sync()

p.

-- 

Peter Meerwald
+43-664-2444418 (mobile)
