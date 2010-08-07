Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0HGPrh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 11:47:37 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:34132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab0HGPrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 11:47:35 -0400
Subject: Re: [PATCH 1/1] integer overflow issue in 'appletouch' driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: Vadim Zaliva <lord@crocodile.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <87k4o234lx.fsf@depni.sinp.msu.ru>
References: <E64899AA-23A5-49D7-8C91-B94A095290E0@crocodile.org>
	 <1268034117.3819.1.camel@jlt3.sipsolutions.net>
	 <36779F26-DB1B-46ED-8635-01B03E559B55@crocodile.org>
	 <20100310062227.GB2445@core.coreip.homeip.net>
	 <87k4o234lx.fsf@depni.sinp.msu.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 17:47:30 +0200
Message-ID: <1281196050.4431.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-07 at 14:00 +0000, Serge Belyshev wrote:
> Hi!
> 
> Since 2.6.34 the touchpad on my feb 2005 powerbook (mod. A1106) has
> stopped working. I've identified the following guilty patch:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=04b4b88cca0ebe3813b4b6f014fb6a0db380b137
> 
> > ... Testing on one of such PowerBooks I have
> > noticed that touchpad always generates positive values, but some of
> > them are greater that 127, and thus, when cast to 'signed char' being
> > interpreted as a negative.
> 
> My device is 05ac:020e "fountain", actually generates *signed* values,
> thus the patch completely breaks it.

I think Ben might have the same issue. I guess we need per-touchpad
functions to read the data.

johannes


