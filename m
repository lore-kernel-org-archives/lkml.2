Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab0HXPFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:05:02 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:44202 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab0HXPFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:05:00 -0400
Date: Tue, 24 Aug 2010 17:06:55 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
Message-ID: <20100824150655.GB2160@osiris.boeblingen.de.ibm.com>
References: <4C61EE55.5030506@codeaurora.org>
 <201008181428.45029.arnd@arndb.de>
 <4C6C3910.80800@codeaurora.org>
 <201008191309.15425.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008191309.15425.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 01:09:15PM +0200, Arnd Bergmann wrote:
> On Wednesday 18 August 2010, Stephen Boyd wrote:
> > So the only sticking point now is that x86, parisc, and arm use warnings 
> > and errors but s390 only uses warnings. I guess I'll reword it to be:
> > 
> >         Enabling this option turns a certain set of sanity checks for
> >         user copy operations into compile time warnings/errors.
> > 
> >         The copy_from_user() etc checks are there to help test if there
> >         are sufficient security checks on the length argument of the
> >         copy operation, by having gcc prove that the argument is
> >         within bounds.
> > 
> >         If unsure, or if you run an older (pre 4.4) gcc where this
> >         option is a no-op, say N.
> > 
> > or I'll add a patch to make s390 trigger an error when this is enabled?
> 
> (Taking Martin and Heiko on Cc for s390)
> 
> I'd strongly suggest making the behavior the same for everyone. It should
> be fairly easy to make sure none of these warnings ever triggers
> on s390, because most of the Linux device driver code does not get build
> there anyway.

Please don't do that. An s390 allyesconfig still triggers 45 warnings and
I'm currently not willing to "patch" working code just to get rid of these
warnings which are most likely all false positives.
That's the reason why we currently don't error out and only generate
warnings.
