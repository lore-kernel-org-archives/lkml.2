Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1ASSWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:22:01 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:50956 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751904Ab1ASSWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:22:00 -0500
Date: Wed, 19 Jan 2011 13:21:42 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] BKL: move CONFIG_BKL to staging
Message-ID: <20110119182142.GA3620@elliptictech.com>
References: <1295385422-3592-1-git-send-email-arnd@arndb.de>
 <1295385422-3592-5-git-send-email-arnd@arndb.de>
 <20110119154419.GA21411@elliptictech.com>
 <201101191717.58277.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101191717.58277.arnd@arndb.de>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-19 17:17 +0100, Arnd Bergmann wrote:
> On Wednesday 19 January 2011, Nick Bowler wrote:
> > I think this patch is not very nice.  It will cause working kernel
> > configurations to turn into broken kernel configurations when the user
> > does 'make oldconfig', with no warning.
> > 
> > These drivers that use the BKL work fine.  Removing working features
> > with no adequate replacement available seems like a serious regression
> > to me.
> 
> I wouldn't call it a serious regression since the code is still there
> and both the symptom and the solution are rather obvious.

Well, the code wouldn't still be there if they're removed in 2.6.39 as
stated in your patch description.  While it may be obvious to people
like you and me who know what the BKL is, I don't it's obvious to
everyone that the cause of "my system doesn't boot anymore" is "oh,
someone moved a dependency of a driver I've been using without issue for
the past 5 years to staging!"

> What's more important is to make any people still relying on the code
> aware that it's going away unless someone fixes it, so they have the
> chance to send patches or pay someone to fix it for them.

Shouldn't the onus for fixing *working* drivers (or encouraging others
to fix them) lie with the person(s) who are so keen to kill off features
that they use?

Surely we don't need to break oldconfig just to raise awareness that
these drivers use deprecated features?

> The remaining drivers that are still relying on the BKL are very
> rarely used and for the less obscure ones (ufs, ipx and x.25), people
> have volunteered to fix them (though I have seen no proper patches
> for these yet).
>
> For the rest, I suppose if nobody complains, they can actually go
> away, according to the logic that if nobody is using them, they most
> likely are broken anyway and more a security risk than they are worth.

Notwithstanding any of the above, one release cycle hardly seems like
enough time to infer from "nobody complained" that "not a single person
uses this driver."  Surely people concerned with security issues in code
that they don't use can just... not enable it?  Nobody's forcing anyone
to use these drivers.

Neither the BKL nor any of these drivers are even mentioned in the
feature removal schedule yet.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
