Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0HGOZO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 10:25:14 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:33362 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab0HGOZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 10:25:12 -0400
X-Greylist: delayed 1490 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Aug 2010 10:25:12 EDT
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
To: Vadim Zaliva <lord@crocodile.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] integer overflow issue in 'appletouch' driver
References: <E64899AA-23A5-49D7-8C91-B94A095290E0@crocodile.org>
	<1268034117.3819.1.camel@jlt3.sipsolutions.net>
	<36779F26-DB1B-46ED-8635-01B03E559B55@crocodile.org>
	<20100310062227.GB2445@core.coreip.homeip.net>
Date: Sat, 07 Aug 2010 14:00:10 +0000
In-Reply-To: <20100310062227.GB2445@core.coreip.homeip.net> (Dmitry Torokhov's
	message of "Tue, 9 Mar 2010 22:22:27 -0800")
Message-ID: <87k4o234lx.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Since 2.6.34 the touchpad on my feb 2005 powerbook (mod. A1106) has
stopped working. I've identified the following guilty patch:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=04b4b88cca0ebe3813b4b6f014fb6a0db380b137

> ... Testing on one of such PowerBooks I have
> noticed that touchpad always generates positive values, but some of
> them are greater that 127, and thus, when cast to 'signed char' being
> interpreted as a negative.

My device is 05ac:020e "fountain", actually generates *signed* values,
thus the patch completely breaks it.
