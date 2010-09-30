Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab0I3UxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:53:22 -0400
Received: from smtp.nokia.com ([192.100.105.134]:47163 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0I3UxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:53:21 -0400
Date: Thu, 30 Sep 2010 23:50:57 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Thomas Gleixner <tglx@linutronix.de>
Cc: "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Bityutskiy Artem (Nokia-MS/Helsinki)" <Artem.Bityutskiy@nokia.com>
Subject: Re: timer: permit statically-declared work with deferrable timers
Message-ID: <20100930205057.GC13742@esdhcp04044.research.nokia.com>
References: <1285874789-1481-1-git-send-email-ext-phil.2.carmody@nokia.com> <alpine.LFD.2.00.1009302207060.2416@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009302207060.2416@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 30 Sep 2010 20:52:26.0010 (UTC) FILETIME=[634D27A0:01CB60E1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/10 22:08 +0200, ext Thomas Gleixner wrote:
> On Thu, 30 Sep 2010, Phil Carmody wrote:
> 
> > 
> > Arjen, Thomas,
> > 
> > This patch is an enabler which hopefully can lead to simplification of code 
> > elsewhere. For example, it would turn Artem's patch I refer to in the commit
> > message (8eab945c5616fc984e97b922d6a2559be93f39a1) into just:
> > 
> > -static DECLARE_DELAYED_WORK(cache_cleaner, do_cache_clean);
> > +static DECLARE_DEFERRED_WORK(cache_cleaner, do_cache_clean);
> > 
> > rather than the creation of a __init helper that required touching 3 files.
> > 
> > I'm prepared to follow up with such simplifying patches if it's considered
> > worthwhile.
> 
> If it simplies stuff, no objections from my side. The patch looks
> reasonable enough.
> 
> How many (ab)users will it clean up ?

Not a large number; absolute tops - a dozen. I've not investigated any apart from
the couple that Artem addressed initially.

And it's OK, the clients weren't the _ab_users. If anything we're the abusers for 
using sleight-of-hand to hide flags inside pointer values. (Which the C standard
and GCC tried hard to stop us doing. Not hard enough, though ;-) .)

My main intention is to make future patches like Artem's trivial. Change the 
type - change one line. Life's too short to headscratch and fight compilers.

Cheers,
Phil
