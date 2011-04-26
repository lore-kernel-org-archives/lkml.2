Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1DZOBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:01:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57905 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab1DZOBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:01:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: guenter.roeck@ericsson.com
Subject: Re: [PATCH v2] misc: Driver for Silicon Labs Si570 and compatibles
Date: Tue, 26 Apr 2011 16:00:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1303248968-5069-1-git-send-email-guenter.roeck@ericsson.com> <20110421233415.GC2786@local> <1303501213.31666.27.camel@groeck-laptop>
In-Reply-To: <1303501213.31666.27.camel@groeck-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104261600.23675.arnd@arndb.de>
X-Provags-ID: V02:K0:9jZGCWdiHAaxCwqmtG89/mV9vhDqd7Nt6x4B0TDS81I
 0ry13QWBgkRZVyLvyJ+1bo0OhblTiocNa++48Br6V5WjX1/FEV
 8JZX7LMo+m+9JXQuQ3k2xjYLUn3y7FOramrS2xYEoKRfh7J7bS
 rf4MTp+LzEXIk7Xp6/4i2ILLu9XRLyGeYDwkzahkn1uBS1+Smj
 JQWV6YROVm/0TXO7kIwOA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 April 2011, Guenter Roeck wrote:
> On Thu, 2011-04-21 at 19:34 -0400, Hans J. Koch wrote:
> > I don't think the UIO framework is the right place for such a thing. If it's
> > just this one driver that needs modification of a clock from userspace, then
> > a sysfs attribute could be added to that driver. If there are several drivers
> > that need this, then the clock framework should be extended.
> 
> Agreed. Also, the desire to control the clock frequency through such a
> driver (user mode or not) seems odd. Such an approach would be
> inherently non-scalable (for my part I would have to support two drivers
> already). Voltage regulators are not controlled through the drivers of
> the chips they are providing power to either, but have an independent
> existence.

I think you are talking about different things here. What I think
Hans was saying is that it should be in the specific UIO driver, not
in the framework, which I can agree with. If we get a bunch of these,
we can still make it generic at a later point, but that is not your
problem.

I think exporting the clock to kernel drivers as a struct clk is
the most useful approach to allow reuse, and then you just have to
interface to that from your existing UIO driver.

	Arnd
