Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab1DKXf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 19:35:59 -0400
Received: from kroah.org ([198.145.64.141]:40954 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab1DKXf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 19:35:57 -0400
Date: Mon, 11 Apr 2011 16:35:06 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        Andy Botting <andy@andybotting.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][PATCH V3] axi: add AXI bus driver
Message-ID: <20110411233506.GA13240@kroah.com>
References: <1302557114-7880-1-git-send-email-zajec5@gmail.com>
 <20110411210631.GA28559@kroah.com>
 <BANLkTim155YxMUVJ=pmVs-rNhkovGPG6OQ@mail.gmail.com>
 <20110411212513.GA17809@kroah.com>
 <BANLkTingqXAWTeOhcL6ER0UJfEdQF5Bo2A@mail.gmail.com>
 <20110411215619.GA27943@kroah.com>
 <BANLkTimjThXn347+=m98NsBXY84guJjNqA@mail.gmail.com>
 <20110411223632.GB31833@kroah.com>
 <BANLkTinpKKRCrBik6-9C5WqcSDGuEt5yCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinpKKRCrBik6-9C5WqcSDGuEt5yCw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 12:45:33AM +0200, Rafał Miłecki wrote:
> 2011/4/12 Greg KH <greg@kroah.com>:
> > On Tue, Apr 12, 2011 at 12:12:47AM +0200, Rafał Miłecki wrote:
> >> 2011/4/11 Greg KH <greg@kroah.com>:
> >> > On Mon, Apr 11, 2011 at 11:36:39PM +0200, Rafał Miłecki wrote:
> >> >> 2011/4/11 Greg KH <greg@kroah.com>:
> >> >> > Please read the documentation for how to do this properly.  I find it
> >> >> > really hard to believe that you wrote that comment instead of putting in
> >> >> > the 2 lines of code required for this function.
> >> >> >
> >> >> > Especially as-it-is, your code does not work properly and leaks memory
> >> >> > badly.  Why would you do that on purpose?
> >> >>
> >> >> I tried to read some documentation about this.
> >> >>
> >> >> 1) driver-mode/device.txt says only that:
> >> >> > Callback to free the device after all references have
> >> >> > gone away. This should be set by the allocator of the
> >> >> > device (i.e. the bus driver that discovered the device).
> >> >> I *really* do not know how my driver should "free" core on AXI bus.
> >> >
> >> > The structure that you have created, added to the bus, is now ready to
> >> > have its memory freed.  So free it.
> >> >
> >> > This usually means something like:
> >> >        struct my_obj = to_my_obj(dev);
> >> >        kfree(my_obj);
> >> > in the release function.
> >>
> >> I register core->dev to the bus (I set core->dev.bus and
> >> core->dev.parent, is that what you mean?). This core->dev is "struct
> >> dev" embedded in "struct axi_device". By embedded I mean it is *not* a
> >> pointer, I do not alloc it, it's part of the "struct axi_device".
> >
> > That is exactly as it should be.
> >
> > Then in your release function, free the struct axi_device.  It's that
> > simple.  To try to free it before then would be wrong and cause
> > problems.
> 
> This is because it is defined as:
> struct axi_device cores[AXI_MAX_NR_CORES];

No way, seriously?

You can't do that, no static struct devices please.  Make these dynamic
and everything will be fine.  The -mm tree used to have a huge warning
if you ever tried to register a statically allocated struct, but that
didn't really work out, but would have saved you a lot of time here,
sorry.

So dynamically allocate the structures and you will be fine.

thanks,

greg k-h
