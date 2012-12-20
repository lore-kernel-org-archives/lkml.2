Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2LTUlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 15:41:05 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41387 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2LTUk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 15:40:57 -0500
Date: Thu, 20 Dec 2012 20:35:14 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Robert Marklund <robert.marklund@stericsson.com>,
        linus.walleij@stericsson.com, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] net/smsc911x: Provide common clock functionality
Message-ID: <20121220203514.GN2691@gmail.com>
References: <1355937587-31730-1-git-send-email-lee.jones@linaro.org>
 <1355937587-31730-4-git-send-email-lee.jones@linaro.org>
 <CACRpkda79O_b3Z8g7Sy7vMtW9neZU4x-Z=iEQgjqu4X5tFKyhw@mail.gmail.com>
 <20121220192441.GC14363@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121220192441.GC14363@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012, Russell King - ARM Linux wrote:

> On Thu, Dec 20, 2012 at 08:12:08PM +0100, Linus Walleij wrote:
> > On Wed, Dec 19, 2012 at 6:19 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > 
> > > Some platforms provide clocks which require enabling before the
> > > SMSC911x chip will power on. This patch uses the new common clk
> > > framework to do just that. If no clock is provided, it will just
> > > be ignored and the driver will continue to assume that no clock
> > > is required for the chip to run successfully.
> > >
> > > Cc: Steve Glendinning <steve.glendinning@shawell.net>
> > > Cc: netdev@vger.kernel.org
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > Seems to me like it'll do the trick.
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> This looks fairly dangerous.  What about those platforms which use this
> driver, but don't provide a clock for it?
> 
> It looks like this will result in those platforms losing their ethernet
> support.  There's at least a bunch of the ARM evaluation boards which
> make use of this driver...

Right, but nothing should regress. If no clock is provided the driver
moves on during the request and will refuse to prepare, enable and
disable there after. 

Unless I've made a mistake somewhere? If so, I'd be happy to fixup.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
