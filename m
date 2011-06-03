Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab1FCPr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:47:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63399 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1FCPr0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:47:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110603152643.GB19344@S2100-06.ap.freescale.net>
References: <1306985632-18820-1-git-send-email-shawn.guo@linaro.org>
 <20110603075201.GE10532@n2100.arm.linux.org.uk> <20110603143406.GA19344@S2100-06.ap.freescale.net>
 <BANLkTi=5kNAt51DP3-rykkT3ZONczD5Crg@mail.gmail.com> <20110603152643.GB19344@S2100-06.ap.freescale.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 3 Jun 2011 09:47:06 -0600
X-Google-Sender-Auth: h_DTbKI4w-cGJxkFYhwnqF4A-H4
Message-ID: <BANLkTi=-YdaU07TrJsbJuZ9SrYi9uV0ACQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Move plat-mxc gpio driver into drivers/gpio
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, arnd@arndb.de,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, olof@lixom.net,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 9:26 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> Hi Grant,
>
> On Fri, Jun 03, 2011 at 08:55:58AM -0600, Grant Likely wrote:
>> On Fri, Jun 3, 2011 at 8:34 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
>> > Hi Russell,
>> >
>> > On Fri, Jun 03, 2011 at 08:52:01AM +0100, Russell King - ARM Linux wrote:
>> >> On Thu, Jun 02, 2011 at 11:33:48AM +0800, Shawn Guo wrote:
>> >> >  arch/arm/plat-mxc/gpio.c                        |  361 -------------------
>> >> >  drivers/gpio/gpio-mxc.c                         |  433 +++++++++++++++++++++++
>> >>
>> > My bad here.  I should have used 'git diff --stat -M' to show the
>> > the following.
>> >
>> > .../arm/plat-mxc/gpio.c => drivers/gpio/gpio-mxc.c |  216 +++++++++++++-------
>> >
>> >> I'm wondering why just moving this driver into drivers/gpio has
>> >> resulted in it growing by 72 lines - and it's not clear from the
>> >> diffs why that is because of the way they're broken up.
>> >>
>> > Yes, I agree.  But when I did something like that to ease the review,
>> > people think it's not necessary :)
>> >
>> > http://permalink.gmane.org/gmane.linux.kernel/1143257
>>
>> The issue was bisectability: it looked like the build would break
>> after applying the first patch.  The first patch should move the
>
> Yes, the build would break only if you change Kconfig/Makefile to
> actually build it.  The patch does not enable the build of the driver
> in the patch.
>
>> driver without breaking the build, and then you can follow up with
>> driver fixes.  I don't want to see functional changes mixed in with
>> the file move change.
>>
> Understood.  Do you want me to resend the gpio-mxs and gpio-mxc patch
> sets for that?  Or can I follow the practice you and Russell
> suggested in the future posts?  I have learnt the lesson.

Please repost.

>
>> > +
>> > +static struct platform_driver mxc_gpio_driver = {
>> > +       .driver         = {
>> > +               .name   = "gpio-mxc",
>>
>> .owner = THIS_MODULE,
>>
> Do I need to re-spin the patch set to fix it, or maintainer (you or
> Sascha) can help to fix it up?
>
> BTW, do you and Sascha get the agreement on which tree the gpio-mxs
> and gpio-mxc should go through?

It will probably go through my tree because there will be a lot of
potentially conflicting GPIO changes going in this cycle.

g.
