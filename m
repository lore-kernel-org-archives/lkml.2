Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2DAWjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 18:39:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58596 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2DAWjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 18:39:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAH+eYFC+q4xFuSdRBkO9nb0XZWU4pQ_yCyinMy2X3ds9WQd1kw@mail.gmail.com>
References: <1333306720-28344-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<CACRpkdYRStgKo_e-4kZKA-V-OoMiV21jRS3R4g1Cq+4c+4=iQA@mail.gmail.com>
	<CAH+eYFC+q4xFuSdRBkO9nb0XZWU4pQ_yCyinMy2X3ds9WQd1kw@mail.gmail.com>
Date: Mon, 2 Apr 2012 00:39:11 +0200
Message-ID: <CACRpkda2zh=zR+A9bwhRXYHtQdFeUpiqG4d5g1i82mPCs1mXaQ@mail.gmail.com>
Subject: Re: [PATCH/RFC v2] ARM: amba: Remove AMBA level regulator support
From: Linus Walleij <linus.walleij@linaro.org>
To: Rabin Vincent <rabin@rab.in>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 9:39 PM, Rabin Vincent <rabin@rab.in> wrote:
> On Mon, Apr 2, 2012 at 00:52, Linus Walleij <linus.walleij@linaro.org> wrote:
>> Combined with the PL022 patch this causes a power regression since
>> the PL022 is hereafter always on.
>
> How can there be a "power regression" here?  This is the only user of
> the vcore regulator, and, apart from the fact that its disable routine
> only decrements an essentialy write-only variable, it is shared which
> several devices which already never disable it.

Yes true... Hm I hope something else in mainline will increase refcount
to vape so it's not disabled at regulator_has_full_constraints()? Better
test it, then I'll see.

Mark: as Rabin says the v1 patch is probably fine, are you pushing this
to ARM SoC or into Russell's patch tracker?

Yours,
Linus Walleij
