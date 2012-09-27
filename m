Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab2I0R1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:27:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39024 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184Ab2I0R1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:27:10 -0400
Date: Thu, 27 Sep 2012 18:26:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joachim Eastwood <manabian@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ming Lei <tom.leiming@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] Deferred probing in driver model is racy, resulting in
 lost probes
Message-ID: <20120927172656.GE4428@opensource.wolfsonmicro.com>
References: <20120818145856.GP18957@n2100.arm.linux.org.uk>
 <CACVXFVPahbFVEP4p2Z9-TvjQ52tUCMuDeLx0X6GP5t0h5gEV8g@mail.gmail.com>
 <20120916082510.GN12245@n2100.arm.linux.org.uk>
 <CACVXFVOZ=4HFAy38q_8ZUjOPffcv_mMTi7KCdh3HcX=MCLw5SQ@mail.gmail.com>
 <20120926200833.GA14340@kroah.com>
 <20120926202321.GD30938@n2100.arm.linux.org.uk>
 <CACVXFVPnpQ6yHiDaoo_CPG7oSEq+ZzxpmTgQv55-tRRyaavDfA@mail.gmail.com>
 <20120927135809.GE14358@n2100.arm.linux.org.uk>
 <20120927140300.GF14358@n2100.arm.linux.org.uk>
 <CAGhQ9VzJtx3MJF1wdJd8hv7Hp4T0YJK=vNbJWGj_W7X+mLy-xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGhQ9VzJtx3MJF1wdJd8hv7Hp4T0YJK=vNbJWGj_W7X+mLy-xQ@mail.gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 07:22:38PM +0200, Joachim Eastwood wrote:

> [   13.140000] sysfs: cannot create duplicate filename
> '/devices/platform/ssc.0/atmel-ssc-dai.0'
> [   13.140000] Modules linked in: snd_soc_mpa1600_wm8776(+)

Oh, dear.  This is probably a genuine bug, triggered by but not really
related to deferred probing.
