Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab0CXAtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 20:49:08 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:32887 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab0CXAtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 20:49:05 -0400
Subject: Re: [PATCH] arm: convert arm to arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100324003409.GB24827@flint.arm.linux.org.uk>
References: <1269385522-2525-1-git-send-email-johnstul@us.ibm.com>
	 <20100324003409.GB24827@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 23 Mar 2010 17:49:02 -0700
Message-ID: <1269391742.2347.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 00:34 +0000, Russell King wrote:
> On Tue, Mar 23, 2010 at 04:05:21PM -0700, John Stultz wrote:
> > Convert arm to use GENERIC_TIME via the arch_getoffset() infrastructure,
> > reducing the amount of arch specific code we need to maintain.
> > 
> > The arm architecture is the last arch that need to be converted.
> 
> Much easier to merge, thanks.
> 
> While looking for a machine to build-test this, I noticed that the IOP/IXP
> platforms have ARCH_USES_GETTIMEOFFSET - yet they select PLAT_IOP which
> in turn selects GENERIC_TIME etc.
> 
> I think ARCH_IOP13XX, ARCH_IOP32X and ARCH_IOP33X shouldn't select
> ARCH_USES_GETTIMEOFFSET - do you agree?

Oh, sorry! I didn't notice the PLAT_IOP was a superset of the IOP
arches, thanks for catching that! 

The generalized rule is: if they have clocksources, then you're right,
ARCH_USES_GETTIMEOFFSET should not be used then (since it disables any
non-jiffies clocksources from being used).

Do you need a new respin removing those lines, or are you comfortable
modifying the patch already sent?

Thanks again for the review and help here!
-john





