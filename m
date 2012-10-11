Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2JKPWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 11:22:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46663 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2JKPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 11:22:46 -0400
MIME-Version: 1.0
In-Reply-To: <BFABBC009FBA1C43B207B15FD485ABD922C22BC4@USW-MAIL1.synaptics-inc.local>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
	<1349496603-20775-2-git-send-email-cheiny@synaptics.com>
	<CACRpkdZb+LOk8v0aNZuPhATjS5jv-h1JJCejoh_9eFZ_fdiZQA@mail.gmail.com>
	<BFABBC009FBA1C43B207B15FD485ABD922C22BC4@USW-MAIL1.synaptics-inc.local>
Date: Thu, 11 Oct 2012 17:22:45 +0200
Message-ID: <CACRpkdY+gWKBbqdPEVPqbZMQABjjJGuejwTBPpZJbkE6k1_Btw@mail.gmail.com>
Subject: Re: [RFC PATCH 01/06] input/rmi4: Public header and documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <Cheiny@synaptics.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 5:41 AM, Christopher Heiny <Cheiny@synaptics.com> wrote:
> Linus Walleij wrote:
>> On Sat, Oct 6, 2012 at 6:09 AM, Christopher Heiny <cheiny@synaptics.com> wrote:

>> > +          chargerinput ... (rw) User space programs can use this to tell
>> > the +                  sensor that the system is plugged into an external
>> > power +                  source (as opposed to running on
>> > batteries).  This allows +                  the sensor firmware to make
>> > necessary adjustments for the +                  current capacitence
>> > regime.  Write 1 to this when the +                  system is using
>> > external power, write 0 to this when the +                  system is
>> > running on batteries.  See spec for full details.
>> I remember discussing in-kernel notifiers for this. I don't
>> really see the point in tunnelling a notification from the drivers/power
>> subsystem to the drivers/input subsystem through userspace for
>> no good.
>>
>> It's no blocker though, I don't expect you to fix this as part of
>> this driver submission.
>>
>> Maybe Anton can comment?
>
> Hmmm.  I agree that it'd be good to avoid looping through userspace.  But....
>
> I found ways to notfiy the kernel that the charger is plugged/unplugged,
> but that's only useful if you're a battery charger device driver.  I also
> found ways for userspace to get notification of charger events.  I
> didn't spot any way for in-kernel drivers to get notification of such
> events.  Perhaps I'm not looking the right places, though - can you
> provide a pointer?

So my point was that there is indeed no such in-kernel
notification mechanism.

Maybe something engineered similar to this:
http://www.spinics.net/lists/lm-sensors/msg33834.html

Yours,
Linus Walleij
