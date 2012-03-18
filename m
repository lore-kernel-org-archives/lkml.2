Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab2CRNjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 09:39:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59288 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752991Ab2CRNi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 09:38:59 -0400
X-Sasl-enc: zWFmmVTvkavJknYA9vMtyosQYzVQ0PAyWjbBmnj2N1ox 1332077938
Date: Sun, 18 Mar 2012 10:38:54 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shuox.liu@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Brown, Len" <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>,
        andi.kleen@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH v4] cpuidle: Add a sysfs entry to disable
 specific C state for debug purpose.
Message-ID: <20120318133854.GA27981@khazad-dum.debian.net>
References: <1331013078.1916.103.camel@ymzhang>
 <20120306143935.GA23346@kroah.com>
 <20120312181151.GE14020@sirena.org.uk>
 <20120312192936.GC24873@kroah.com>
 <1331602594.1916.155.camel@ymzhang>
 <20120313192949.GA8568@kroah.com>
 <1331686500.1916.172.camel@ymzhang>
 <20120314024619.GC22955@kroah.com>
 <4F600F78.2060902@intel.com>
 <20120316143355.f2dddbbd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120316143355.f2dddbbd.akpm@linux-foundation.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012, Andrew Morton wrote:
> > +#define define_store_state_function(_name) \
> > +static ssize_t store_state_##_name(struct cpuidle_state *state, \
> > +		const char *buf, size_t size) \
> > +{ \
> > +	long value; \
> > +	if (!capable(CAP_SYS_ADMIN)) \
> > +		return -EPERM; \
> 
> Is the capability check required?  The 0644 permissions aren't sufficient?

That depends.  Without capable(), restricted root (one which had its
capabilities dropped) can disable idle states.

If you want to restrict something to "root only", IMHO it should be
using capable(), as restricted root really doesn't qualify for "root
only" things.

If you wanted to restrict it to "owner only" OTOH, then yes, the
capable() check (especially with the very coarse set of capabilities we
currently have) might not be desireable.

However, if we had a power-management capability, it would be best to
use that one instead of CAP_SYS_ADMIN (aka "the new root" as LWN called
it).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
