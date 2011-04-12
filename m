Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab1DLPSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:18:00 -0400
Received: from kroah.org ([198.145.64.141]:46277 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab1DLPR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:17:59 -0400
Date: Tue, 12 Apr 2011 08:14:53 -0700
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
Message-ID: <20110412151453.GA20978@kroah.com>
References: <20110411210631.GA28559@kroah.com>
 <BANLkTim155YxMUVJ=pmVs-rNhkovGPG6OQ@mail.gmail.com>
 <20110411212513.GA17809@kroah.com>
 <BANLkTingqXAWTeOhcL6ER0UJfEdQF5Bo2A@mail.gmail.com>
 <20110411215619.GA27943@kroah.com>
 <BANLkTimjThXn347+=m98NsBXY84guJjNqA@mail.gmail.com>
 <20110411223632.GB31833@kroah.com>
 <BANLkTinpKKRCrBik6-9C5WqcSDGuEt5yCw@mail.gmail.com>
 <20110411233506.GA13240@kroah.com>
 <BANLkTi=cG3U8yXaQ6PusmNaWcr+AWv3e_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=cG3U8yXaQ6PusmNaWcr+AWv3e_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 07:41:18AM +0200, Rafał Miłecki wrote:
> > You can't do that, no static struct devices please.  Make these dynamic
> > and everything will be fine.  The -mm tree used to have a huge warning
> > if you ever tried to register a statically allocated struct, but that
> > didn't really work out, but would have saved you a lot of time here,
> > sorry.
> >
> > So dynamically allocate the structures and you will be fine.
> 
> Well, I saw that along kernel, I had no idea there is anything wrong
> about this. It seems more ppl do not know about this:
> struct radeon_ib	ibs[RADEON_IB_POOL_SIZE];
> struct radeon_pm_clock_info clock_info[8];
> struct radeon_pm_profile profiles[PM_PROFILE_MAX];
> struct radeon_surface_reg surface_regs[RADEON_GEM_MAX_SURFACES];

Are you sure these are all containing a 'struct device'?

> struct radeon_i2c_chan *i2c_bus[RADEON_MAX_I2C_BUS];

This is an array of pointers, that's fine.

> struct b43_key key[B43_NR_GROUP_KEYS * 2 + B43_NR_PAIRWISE_KEYS];

This contains a 'struct device'?

> struct ssb_device devices[SSB_MAX_NR_CORES];
> I guess I could fine more examples by simple grepping .h files.

Then all of the above should be fixed.

> Is there some guide around with things like this we should avoid?

Yes, do not statically allocate a 'struct device'.

> checkpatch does no catch this, so maybe just some manual? Could you
> point me to it?

It's a structure that has dynamic lifetime rules, you can't statically
allocate it safely.  It's that simple.

Please fix this.

thanks,

greg k-h
