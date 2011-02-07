Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1BGWYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 17:24:04 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57921 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab1BGWYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 17:24:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vj/Y+gwflpcx8SSYXTOPr8Yx3Cd3cpfZPkJ9fzW13IHkPhk3Taz5S3sy/wwr30rFgF
         WYNFP0ojuoHHyCgXdEZz0pIjZWYSGT1XCzLIoDIfZcwy/oVBanL2UKgkXHP8+j4td15J
         +BF5q9v4Zh+42LNUvVBRrHs3uteaekn0LCDJk=
Date: Mon, 7 Feb 2011 14:23:50 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-embedded@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
Message-ID: <20110207222350.GA24804@core.coreip.homeip.net>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <201102072215.59921.rjw@sisk.pl>
 <20110207214732.GA24703@core.coreip.homeip.net>
 <201102072300.03986.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102072300.03986.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 11:00:03PM +0100, Rafael J. Wysocki wrote:
> On Monday, February 07, 2011, Dmitry Torokhov wrote:
> > On Mon, Feb 07, 2011 at 10:15:59PM +0100, Rafael J. Wysocki wrote:
> > > On Monday, February 07, 2011, Mark Brown wrote:
> > > > 
> > > > Yeah, but some people seem very keen on removing the pointers to the PM
> > > > ops entirely when CONFIG_PM is disabled which means that you end up with
> > > > varying idioms for what you do with the PM ops as stuff gets ifdefed
> > > > out.  Then again I'm not sure anything would make those people any
> > > > happier.
> > > 
> > > I really think we should do things that makes sense rather that worry about
> > > who's going to like or dislike it (except for Linus maybe, but he tends to like
> > > things that make sense anyway).  At this point I think the change I suggested
> > > makes sense, because it (a) simplifies things and (b) follows the quite common
> > > practice which is to make PM callbacks depend on CONFIG_PM.
> > 
> > Many people make these callback dependent on PM not because it makes
> > much sense but because it is possible to do so. However, aside of
> > randconfig compile testing, nobody really tests drivers that implement
> > PM in the !CONFIG_PM setting.
> 
> That I can agree with, but I'm not sure whether it is an argument against
> the patch I've just posted or for it?

More of an observation for your (b) justification. I'd probably force
CONFIG_PM to always 'y'w while we weeding references to it from
drivers...

-- 
Dmitry
