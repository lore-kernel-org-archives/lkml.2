Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab1BGTrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:47:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51383 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab1BGTrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:47:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
Date: Mon, 7 Feb 2011 20:46:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <len.brown@intel.com>, Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201102072014.04259.rjw@sisk.pl> <20110207193026.GT10564@opensource.wolfsonmicro.com>
In-Reply-To: <20110207193026.GT10564@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102072046.48763.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 07, 2011, Mark Brown wrote:
> On Mon, Feb 07, 2011 at 08:14:03PM +0100, Rafael J. Wysocki wrote:
> > On Monday, February 07, 2011, Mark Brown wrote:
> 
> > >  config PM_DEBUG
> > >  	bool "Power Management Debug Support"
> 
> > I think it would be better to simply rename CONFIG_PM_OPS into CONFIG_PM.
> 
> That still leaves the IA64 emulator to worry about

Why exactly?

> but I'm not fundamentally opposed to that, it achieves a similar effect.  The
> main thing I'm looking for here is to cut down on the configuration options
> we have to maintain.

But I must say you chose a particularly bad time for that from my point of view.

> > However, there's a number of things that I'm afraid wouldn't build correctly
> > if none of CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME were set in that case.
> 
> Actually CONFIG_PM_OPS probably also wants to be on independantly of
> those two sometimes for .poweroff() which I'd expect to run even if we
> can't suspend.

If you worry about that, then add CONFIG_PM_POWEROFF and make CONFIG_PM(_OPS)
depend on it, but I don't think it really is worth it, because people
generally don't make the poweroff code depend on CONFIG_PM.

Thanks,
Rafael
