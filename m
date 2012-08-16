Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab2HPNug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:50:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39480 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab2HPNud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:50:33 -0400
Date: Thu, 16 Aug 2012 16:50:27 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: dedekind1@gmail.com
Cc: Richard Genoud <richard.genoud@gmail.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] UBI: replace MTD_UBI_BEB_LIMIT with user-space
 parameter
Message-ID: <20120816165027.6520c4f4@pixies.home.jungo.com>
In-Reply-To: <1345123718.3393.235.camel@sauron.fi.intel.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	<1341937423-16516-5-git-send-email-richard.genoud@gmail.com>
	<20120816115713.726da8f2@pixies.home.jungo.com>
	<1345123718.3393.235.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012 16:28:38 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Thu, 2012-08-16 at 11:57 +0300, Shmulik Ladkani wrote:
> > 
> > For the simplest systems (those having one ubi device) that need a
> > limit
> > *other* than the default (20 per 1024), they can simply set the config
> > to their chosen value, as they were used to.
> > 
> > With you approach, these system MUST pass the limit parameter via the
> > ioctl / module-parameter. 
> 
> Yeah, when you change the default, you usually need to do an extra step.
> It does not feel too bad, and I would not keep additional configuration
> option for a hypothetical user. If someone suffers, we can add an option
> to change the default. But I'd start without it. So, I think it is OK to
> remove this.

Yes, but the main drawback I was referring to is those platforms already
setting MTD_UBI_BEB_RESERVE other than the default, by means of kernel
configuration.
(there's one platform known to do so in its defconfig, that's
sam9_l9260_defconfig, which uses 3% instead of the "standard" 2%).

These platforms must now change their usermode code to either pass a
module parameter during the insmod or change their attach ioctl of
their application.

We force these systems to change their usermode because we changed ubi's
default BEB limit to be 20/1024 _hardcoded_ (instead of kernel
configurable as previously was).

Is this ok?

Regards,
Shmulik
