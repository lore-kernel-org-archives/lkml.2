Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1JXHgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 03:36:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39549 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab1JXHgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 03:36:13 -0400
Date: Mon, 24 Oct 2011 09:36:04 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>, David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Stijn Devriendt <highguy@gmail.com>
Subject: Re: [PATCH] drivers: create a pin control subsystem v8
Message-ID: <20111024073604.GA8708@ponder.secretlab.ca>
References: <1317211419-18472-1-git-send-email-linus.walleij@stericsson.com>
 <20110930020754.GK12606@ponder.secretlab.ca>
 <CACRpkdYyyqB6=5M8reqgwpMxXJz5ttXWyOav6K58dQ0CrxwCNA@mail.gmail.com>
 <CACxGe6v19pZ0i-+ksYZbG2ZvGT30UkXEHTzpZMBTB4RNUV5bnA@mail.gmail.com>
 <CAKnu2MpQ8Wvd4TF8Ge=o8ACyEoaEY8TcvOSdT1w6zfYiSKFUiw@mail.gmail.com>
 <20111004203520.GK2870@ponder.secretlab.ca>
 <CAMjpGUe9abPsdWbum2MRzOV2b5_2FDqXZC-K0KThRA6MNTr4FA@mail.gmail.com>
 <CACRpkdatiBathcoo2VjKs9jHJiKC5trDCJ0bePX1q6KbrYRN-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdatiBathcoo2VjKs9jHJiKC5trDCJ0bePX1q6KbrYRN-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 09:26:38AM +0200, Linus Walleij wrote:
> On Sat, Oct 22, 2011 at 7:44 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> > On Tue, Oct 4, 2011 at 16:35, Grant Likely wrote:
> >> On Sat, Oct 01, 2011 at 12:39:21PM +0200, Linus Walleij wrote:
> >>> 2011/9/30 Grant Likely:
> >>> > I'm not convinced that the sysfs approach is
> >>> > actually the right interface here (I'm certainly not a fan of the gpio
> >>> > sysfs i/f), and I'd rather not be putting in unneeded stuff until the
> >>> > userspace i/f is hammered out.
> >>>
> >>> Actually, thinking about it I cannot see what would be wrong
> >>> with /dev/gpio0 & friends in the first place.
> >>>
> >>> Using sysfs as swiss army knife for custom I/O does not
> >>> seem like it would be long-term viable so thanks for this
> >>> observation, and I think we need /dev/gpio* put on some
> >>> mental roadmap somewhere.
> >>
> >> Agreed.  I don't want to be in the situation we are now with GPIO,
> >> where every time I look at the sysfs interface I shudder.
> >
> > the problem with that is it doesn't scale.  if i have a device with
> > over 150 GPIOs on the SoC itself (obviously GPIO expanders can make
> > that much bigger), i don't want to see 150+ device nodes in /dev/.
> > that's a pretty big waste.  sysfs only allocates/frees resources when
> > userspace actually wants to utilize a GPIO.
> 
> I was more thinking along the lines of one device per GPIO controller,
> then you ioctl() to ask /dev/gpio0 how many pins it has or so.

And there is also the question of whether it is even a good idea to
export pinctrl manipulation to userspace.

g.

