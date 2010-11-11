Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab0KKBrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 20:47:01 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11065 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab0KKBq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 20:46:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Wed, 10 Nov 2010 17:46:52 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Andrew Chew <AChew@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 10 Nov 2010 17:46:28 -0800
Subject: RE: [PATCH v2] POWER: Add gpio charger driver
Thread-Topic: [PATCH v2] POWER: Add gpio charger driver
Thread-Index: AcuBQItjSJ+E6ut8SY2cj+wG38gEyQAAKu5w
Message-ID: <E88A1D35AF5437468E5B14C7C4BA61C702D41B4F5B@HQMAIL01.nvidia.com>
References: <1287663957-30099-1-git-send-email-lars@metafoo.de>
 <1287676501-23254-1-git-send-email-lars@metafoo.de>
 <20101021162617.GA10447@oksana.dev.rtsoft.ru> <4CC07CB4.9060108@metafoo.de>
 <E88A1D35AF5437468E5B14C7C4BA61C702D3E13FB3@HQMAIL01.nvidia.com>
 <20101104174746.GA16349@oksana.dev.rtsoft.ru>
 <E88A1D35AF5437468E5B14C7C4BA61C702D41B4F4F@HQMAIL01.nvidia.com>
 <4CDB47FB.1050004@metafoo.de>
In-Reply-To: <4CDB47FB.1050004@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAB1lJWG001374

> From: Lars-Peter Clausen [mailto:lars@metafoo.de]
> Sent: Wednesday, November 10, 2010 5:34 PM
> To: Rhyland Klein
> Cc: Anton Vorontsov; broonie@opensource.wolfsonmicro.com; Andrew Chew;
> olof@lixom.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] POWER: Add gpio charger driver
> 
> Rhyland Klein wrote:
> >> From: Anton Vorontsov [mailto:cbouatmailru@gmail.com]
> >> Sent: Thursday, November 04, 2010 10:48 AM
> >> To: Rhyland Klein
> >> Cc: Lars-Peter Clausen; broonie@opensource.wolfsonmicro.com; Andrew
> Chew;
> >> olof@lixom.net; linux-kernel@vger.kernel.org
> >> Subject: Re: [PATCH v2] POWER: Add gpio charger driver
> >>
> >> On Thu, Oct 28, 2010 at 02:17:41PM -0700, Rhyland Klein wrote:
> >> [...]
> >>>> Hm... I guess it can be, but on the other hand most platform bus
> >> chargers
> >>>> type
> >>>> devices can be, because the pda_power driver is keep pretty generic
> >> with
> >>>> custom init,
> >>>> status and exit callbacks.
> >>>>
> >>>> - Lars
> >>> I didn't see any more discussion on this. Is the plan to integrate
> >>> the gpio-charger driver as is or to instead try to integrate support
> >>> for this into pda_power?
> >> Sorry for the delayed response, and thanks for the pings! ;-)
> >>
> >> The main thing I'm afraid of is duplication. I.e. someday you
> >> will want debouncing (include/linux/pda_power.h's wait_for_status,
> >> wait_for_charger parameters) support, regulators support etc.
> >>
> >> And your gpio driver will look very similar to pda_power.
> >>
> >> So I'd vote for adding the GPIO functionality to pda_power, and
> >> refactoring it if needed.
> >>
> >> Though, if there are strong objections against this idea, I
> >> can merge the GPIO driver, and let's see how things will evolve.
> >>
> >> Thanks!
> >>
> >> --
> >> Anton Vorontsov
> >> email: cbouatmailru@gmail.com
> >> irc://irc.freenode.net/bd2
> >
> > My guess, is that since no one has responded, no one is working on
> integrating the functionality into pda-power?
> >
> > -rhyland
> 
> hi
> 
> Well I'm still not convinced that both drivers should be merged, yet I'm
> not totally
> opposed to it. In my opinion we are in some kind of dilemma here.
> I can see Antons point regarding to introducing code duplication, but on
> the other
> hand you'll always have code duplication amongst similar drivers. This will
> especially stand out if the setup functions take up a relatively large part
> of the
> whole code size.
> One way to avoid this is by putting everything into one driver which
> handles all
> different cases. But the next time yet another sort of similar driver comes
> along
> another if-else-branch is added to the pda-power driver. And slowly over
> time things
> will get messy.
> Another option to solve the problem is to add another level of indirection.
> For
> example in form of a simple_charger driver which will take callbacks for
> add, remove
> and status. The gpio-charger and pda-power could then instantiate such a
> driver and
> provide their callbacks. But by adding more and more levels of indirection
> things
> will slowly get messy as well.
> One solution that might could work is to provide library functions which
> aim at
> providing aid for implementing (simple) charger drivers.
> 
> - Lars

Well, this is how I look at it. For now, we can integrate the generic gpio-charger driver. Then there are 2 concerns. If someone wants a gpio-charger with more functionality that duplicates what pda-power does, then maybe the correct thing to do is to make a new driver instead of trying to extend gpio-charger. Also, if we put in the gpio-charger now, we can still work to integrate that functionality into pda-power, and then deprecate gpio-charger.

-rhyland
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
