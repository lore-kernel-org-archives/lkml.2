Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab0EFVGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 17:06:05 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35598 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958Ab0EFVF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 17:05:59 -0400
Subject: Re: kbuild: fixing the select problem
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-arch@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <20100506135952.eeb0e4c5.randy.dunlap@oracle.com>
References: <1273096160.23208.35.camel@mulgrave.site>
	 <4BE2D10D.4070706@suse.cz> <1273157554.23208.69.camel@mulgrave.site>
	 <1273178915.2881.20.camel@mulgrave.site>
	 <20100506135952.eeb0e4c5.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 16:05:56 -0500
Message-ID: <1273179956.2881.23.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 13:59 -0700, Randy Dunlap wrote:
> On Thu, 06 May 2010 15:48:35 -0500 James Bottomley wrote:
> 
> > On Thu, 2010-05-06 at 09:52 -0500, James Bottomley wrote:
> > > The list is
> > > 
> > > USB_ARCH_HAS_HCD has 4 defaults
> > > DEFCONFIG_LIST has 5 defaults
> > > MAC80211_RC_DEFAULT has 2 defaults
> > > X86_L1_CACHE_SHIFT has 2 defaults
> > > SPLIT_PTLOCK_CPUS has 2 defaults
> > > X86_MINIMUM_CPU_FAMILY has 3 defaults
> > > DEFAULT_TCP_CONG has 2 defaults
> > > DEFCONFIG_LIST has 5 defaults
> > > USB_ARCH_HAS_HCD has 4 defaults
> > > X86_L1_CACHE_SHIFT has 2 defaults
> > > X86_MINIMUM_CPU_FAMILY has 3 defaults
> > > SPLIT_PTLOCK_CPUS has 2 defaults
> > > DEFAULT_TCP_CONG has 2 defaults
> > > MAC80211_RC_DEFAULT has 2 defaults
> > 
> > Here's a patch that alters the default processing to the needed form and
> > checks the old vs new values.  I've been running randconfigs but I can't
> > get the warning to trip ... have at it.
> > 
> 
> I don't see the warning, but I took a problem config from linux-next 2010-0506
> (today) [attached].  In it, CONFIG_TCG_BIOS_LOG=y and that selects ACPI,
> so now ACPI is enabled, but ACPI depends on PM and PCI, but they are still not
> selected...
> 
> or is this only step 1 of a multi-step implementation?

Actually, it's not any step.  It's just validation of the contention
that I can alter the default parser from taking the first valid default
to calculating the or of the defaults without changing the current
kbuild behaviour.

The patch to fix kbuild goes on top of this change minus the warnings
(when I actually code it up).

James


