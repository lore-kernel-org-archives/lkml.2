Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab2IKNju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:39:50 -0400
Received: from skyrme.org ([193.175.80.135]:57712 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab2IKNjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:39:48 -0400
Date: 11 Sep 2012 13:39:44 +0000
Message-ID: <20120911133944.GA2537@curry>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Wim Van Sebroeck" <wim@iguana.be>
Cc: "Oskar Schirmer" <oskar@scara.com>, "Sascha Hauer" <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org, "Wolfram Sang" <w.sang@pengutronix.de>,
        " Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] watchdog/imx2+: add support for pretimeout interrupt functionality
References: <1338460658-16067-1-git-send-email-oskar@scara.com> <1347357652-23601-1-git-send-email-oskar@scara.com> <20120911110021.GG27604@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120911110021.GG27604@spo001.leaseweb.com>
User-Agent: Mutt/1.4.2.3i
Organisation: www.embedded-group.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

On Tue, Sep 11, 2012 at 13:00:21 +0200, Wim Van Sebroeck wrote:
> Hi Oskar,
> 
> > This watchdog device provides pretimeout facilities:
> > Set some timeout value and get informed about imminent
> > watchdog activity thru interrupt.
> > 
> > Allow user to wait for this interrupt thru poll(2),
> > and to clear it thru read(2).
> > 
> > Signed-off-by: Oskar Schirmer <oskar@scara.com>
> > Cc: Wim Van Sebroeck <wim@iguana.be>
> > Cc: Wolfram Sang <w.sang@pengutronix.de>
> > Cc: Sascha Hauer <kernel@pengutronix.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> I have a problem with the read and poll.
> We had "read()" in the past so we have a possible issue here (different function but userspace apps could still use the old read)...
> Can you explain what the read and poll does and where you want to use it.

To wait for some hardware event without blocking,
poll is used, primarily in places where it's about
data transmission. Ioctl would be an alternative
for cases without data transmission, but poll is
more generic.

Events causing pollin to return usually provide
data for read access, or, where no data is involved,
at least allow to clear the event thru read.

Now, checking current kernel for precedent, there
is only one driver that comes with pretimeouts: ipmi_watchdog.
It allows to set/get pretimeout, wait for it thru poll,
and clear it's occurence thru read.

So the obvious approach is to have a similar api for
the imx watchdog, as well, to avoid conflicting designs
right away.

Documentation does introduce set/get pretimeout, but
does not define how to detect and clear events.
Actually it does not define any meaning of poll or read.
Maybe this should be added.

For the past use of read, could You point me to where
imx2_wdt.c did have it?

There are watchdog drivers around that do implement a
read function, most of them to read temperature values.
Temperature sensor and watchdog are quite
different functionalities, so even where provided by
a single piece of hardware they probably should go
along two distinct drivers to make it a clean design.

Grüße,
  Oskar
