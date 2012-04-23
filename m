Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2DWWWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:22:32 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:36833 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab2DWWWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:22:31 -0400
Message-ID: <1335219745.2850.7.camel@lorien2>
Subject: Re: [PATCH ] leds: add new transient trigger for one shot timer
 support
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: NeilBrown <neilb@suse.de>, Jonas Bonn <jonas@southpole.se>
Cc: shuahkhan@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Date: Mon, 23 Apr 2012 16:22:25 -0600
In-Reply-To: <20120423154546.415bd6c0@notabene.brown>
References: <1333310039.2879.4.camel@lorien2> <1334064283.10826.6.camel@ted>
	 <1334507752.2723.3.camel@lorien2> <1334894674.3051.18.camel@lorien2>
	 <1334983269.2435.90.camel@jerome.southpole.se>
	 <1335138687.2882.20.camel@lorien2> <20120423115610.2da4d4d7@notabene.brown>
	 <1335158999.5139.47.camel@jerome.southpole.se>
	 <20120423154546.415bd6c0@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 15:45 +1000, NeilBrown wrote:
> On Mon, 23 Apr 2012 07:29:59 +0200 Jonas Bonn <jonas@southpole.se> wrote:
> 
> > 
> > On Mon, 2012-04-23 at 11:56 +1000, NeilBrown wrote:
> > > I wonder if we should allow control of the brightness during the "on" time as
> > > well.
> > > You could set the brightness after enabling the timer, but awkward pauses or
> > > races could then leave the "led" permanently on.
> > 
> > echo transient > trigger
> > echo 200 > duration
> > echo 1 > activate
> context switch - lots of IO - time passes, 200ms or more, led gets turned of
> and then back to:
> > echo 100 > brightness
> 
> led gets turned on and there is nothing to turn it off.
> 
> Not a likely case I agree, but not impossible.
> 
> The problem is that just setting the brightness will turn the led on
> independent of the start of the trigger (unless you set the brightness to 0 -
> that disables the trigger).
> 
Neil/Jonas,

Thanks for a good discussion and ideas. Are you okay with supporting the
following use-case as a first cut implementation and see how that works
and then add brightness adjustment later?

echo transient > trigger
echo 200 > duration
echo 1 > activate

I am taking a look at "safe_delay_show" and "safe_delay_store" in
drivers/md/md.c. I think I can easily change what I have now to do what
these routines do. i.e going with seconds as units based on Neil's
suggestion.

I did make the change to name the properties duration and activate,
dropping the transient pre-fix on both properties.

Thanks,
-- Shuah

