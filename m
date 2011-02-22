Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab1BVU3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:29:45 -0500
Received: from smtp.outflux.net ([198.145.64.163]:59059 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab1BVU3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:29:44 -0500
Date: Tue, 22 Feb 2011 12:28:56 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
        Eugene Teo <eugeneteo@kernel.sg>,
        Ralph Campbell <infinipath@qlogic.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, James Morris <jmorris@namei.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, Nick Piggin <npiggin@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ian.campbell@citrix.com>,
        Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>,
        Tejun Heo <tj@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] debugfs: only allow root access to debugging
 interfaces
Message-ID: <20110222202856.GE4000@outflux.net>
References: <1298398198-18482-1-git-send-email-kees.cook@canonical.com>
 <1298398198-18482-2-git-send-email-kees.cook@canonical.com>
 <20110222181613.GU4000@outflux.net>
 <4D640133.9020901@caviumnetworks.com>
 <20110222184726.GV4000@outflux.net>
 <20110222191454.GB9991@suse.de>
 <20110222192532.GY4000@outflux.net>
 <20110222193418.773ccd4b@lxorguk.ukuu.org.uk>
 <20110222195018.GA4000@outflux.net>
 <20110222201610.GA29787@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222201610.GA29787@suse.de>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 12:16:10PM -0800, Greg KH wrote:
> On Tue, Feb 22, 2011 at 11:50:18AM -0800, Kees Cook wrote:
> > On Tue, Feb 22, 2011 at 07:34:18PM +0000, Alan Cox wrote:
> > > > What system do you proposed to keep these "stupid mistakes" from
> > > > continuing to happen? If debugfs had already been mode 0700, we could have
> > > > avoided all of these CVEs, including the full-blown local root escalation.
> > > 
> > > And all sorts of features would have put themselves in sysfs instead and
> > > broken no doubt.
> > > 
> > > > The "no rules" approach to debugfs is not a good idea, IMO.
> > > 
> > > It's a debugging fs, it needs to be "no rules" other than the obvious
> > > "don't mount it on production systems"
> > 
> > Okay, so the debugfs is not supposed to be mounted on a production system.
> 
> No, not true at all, the "enterprise" distros all mount debugfs for good
> reason on their systems.

What reasons are those? Or better yet, why do you and Alan Cox disagree on
this point?

> > This seems to be news to a lot of developers trying to use the interfaces
> > exposed there. It would be nice to say this more loudly.  Basically,
> > a normal system should not depend on anything in the debugfs. I can get
> > behind that.
> 
> Again, not true.  Mostly all due to the perf interface, fix that to move
> out of debugfs (patches have been proposed) and this problem will go
> away.

You can't have "no rules" and "all distros mount debugfs for good reason".
This is asking for (even more) trouble. If there is something universally
useful in debugfs (I do not count perf as universally useful -- my parents
do not use perf), then why is it living in a filesystem with no rules
(where "no rules" seems to also include "don't break interfaces").

-Kees

-- 
Kees Cook
Ubuntu Security Team
