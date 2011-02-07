Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab1BGUSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 15:18:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59373 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754044Ab1BGUSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 15:18:07 -0500
Date: Mon, 7 Feb 2011 20:18:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>, Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
Message-ID: <20110207201803.GU10564@opensource.wolfsonmicro.com>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <201102072014.04259.rjw@sisk.pl>
 <20110207193026.GT10564@opensource.wolfsonmicro.com>
 <201102072046.48763.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102072046.48763.rjw@sisk.pl>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 08:46:48PM +0100, Rafael J. Wysocki wrote:
> On Monday, February 07, 2011, Mark Brown wrote:
> > On Mon, Feb 07, 2011 at 08:14:03PM +0100, Rafael J. Wysocki wrote:

> > > I think it would be better to simply rename CONFIG_PM_OPS into CONFIG_PM.

> > That still leaves the IA64 emulator to worry about

> Why exactly?

Actually not so much the IA64 emulator (which does have the !PM
dependency declared already - I expect that'd just be moved) as any
other platforms with an undeclared dependency on !PM.

> > but I'm not fundamentally opposed to that, it achieves a similar effect.  The
> > main thing I'm looking for here is to cut down on the configuration options
> > we have to maintain.

> But I must say you chose a particularly bad time for that from my point of view.

This doesn't seem like it's a worse time than any other?

> > > However, there's a number of things that I'm afraid wouldn't build correctly
> > > if none of CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME were set in that case.

> > Actually CONFIG_PM_OPS probably also wants to be on independantly of
> > those two sometimes for .poweroff() which I'd expect to run even if we
> > can't suspend.

> If you worry about that, then add CONFIG_PM_POWEROFF and make CONFIG_PM(_OPS)
> depend on it, but I don't think it really is worth it, because people
> generally don't make the poweroff code depend on CONFIG_PM.

Yeah, but some people seem very keen on removing the pointers to the PM
ops entirely when CONFIG_PM is disabled which means that you end up with
varying idioms for what you do with the PM ops as stuff gets ifdefed
out.  Then again I'm not sure anything would make those people any
happier.
