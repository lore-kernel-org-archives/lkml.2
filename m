Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab1A0Bal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 20:30:41 -0500
Received: from smtp.outflux.net ([198.145.64.163]:54081 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494Ab1A0Bak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:30:40 -0500
Date: Wed, 26 Jan 2011 17:30:19 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, Marcus Meissner <meissner@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Eugene Teo <eugeneteo@kernel.org>, Joe Perches <joe@perches.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>,
        Changli Gao <xiaosuo@gmail.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>
Subject: Re: [PATCH] use %pK for /proc/kallsyms and /proc/modules
Message-ID: <20110127013019.GJ4981@outflux.net>
References: <20110125181058.GA25670@outflux.net>
 <20110126155706.0188fe02.akpm@linux-foundation.org>
 <20110127002936.GG4981@outflux.net>
 <20110126164650.ef5bd302.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126164650.ef5bd302.akpm@linux-foundation.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 04:46:50PM -0800, Andrew Morton wrote:
> On Wed, 26 Jan 2011 16:29:36 -0800
> Kees Cook <kees.cook@canonical.com> wrote:
> 
> > > > Note that this changes %x to %p, so some legitimately 0 values in
> > > > /proc/kallsyms would have changed from 00000000 to "(null)". To avoid
> > > > this, "(null)" is not used when using the "K" format. Anything parsing
> > > > such addresses should have no problem with this change. (Thanks to Joe
> > > > Perches for the suggestion.)
> > > 
> > > OK, so what applications did this patch just break?
> > 
> > I'm not aware of any breakage as a result of this yet.
> 
> There will be some - there always are :( But users will only see
> problems if they've set kptr_restrict.

If something can parse "null", "00000001" through "99999999", and _not_
"00000000", I will happily giggle at them. :)

> 
> Which they shall do.  How come we defaulted kptr_restrict to "true"?

Because that's the correct value! :) Unprivileged userspace doesn't need to
see kernel addresses by default, that's for CAP_SYSLOG.

-Kees

-- 
Kees Cook
Ubuntu Security Team
