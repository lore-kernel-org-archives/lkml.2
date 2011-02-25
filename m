Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab1BYAXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 19:23:08 -0500
Received: from smtp.outflux.net ([198.145.64.163]:45827 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756647Ab1BYAXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 19:23:06 -0500
Date: Thu, 24 Feb 2011 16:22:14 -0800
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
Message-ID: <20110225002214.GW4212@outflux.net>
References: <4D640133.9020901@caviumnetworks.com>
 <20110222184726.GV4000@outflux.net>
 <20110222191454.GB9991@suse.de>
 <20110222192532.GY4000@outflux.net>
 <20110222193418.773ccd4b@lxorguk.ukuu.org.uk>
 <20110222195018.GA4000@outflux.net>
 <20110222201610.GA29787@suse.de>
 <20110222202856.GE4000@outflux.net>
 <20110222203704.GA7224@suse.de>
 <20110222205413.GH4000@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222205413.GH4000@outflux.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, Feb 22, 2011 at 12:54:13PM -0800, Kees Cook wrote:
> On Tue, Feb 22, 2011 at 12:37:04PM -0800, Greg KH wrote:
> > On Tue, Feb 22, 2011 at 12:28:56PM -0800, Kees Cook wrote:
> > > On Tue, Feb 22, 2011 at 12:16:10PM -0800, Greg KH wrote:
> > > > On Tue, Feb 22, 2011 at 11:50:18AM -0800, Kees Cook wrote:
> > > > > On Tue, Feb 22, 2011 at 07:34:18PM +0000, Alan Cox wrote:
> > > > > > > What system do you proposed to keep these "stupid mistakes" from
> > > > > > > continuing to happen? If debugfs had already been mode 0700, we could have
> > > > > > > avoided all of these CVEs, including the full-blown local root escalation.
> > > > > > 
> > > > > > And all sorts of features would have put themselves in sysfs instead and
> > > > > > broken no doubt.
> > > > > > 
> > > > > > > The "no rules" approach to debugfs is not a good idea, IMO.
> > > > > > 
> > > > > > It's a debugging fs, it needs to be "no rules" other than the obvious
> > > > > > "don't mount it on production systems"
> > > > > 
> > > > > Okay, so the debugfs is not supposed to be mounted on a production system.
> > > > 
> > > > No, not true at all, the "enterprise" distros all mount debugfs for good
> > > > reason on their systems.
> > > 
> > > What reasons are those? Or better yet, why do you and Alan Cox disagree on
> > > this point?
> > 
> > These distros have made the decision to support the perf interface,
> > which lives in debugfs, for their customers.  I'm not saying that I
> > disagree with Alan about this, just pointing out the reality of the
> > situation here.
> 
> A tool used only by the root user, so the proposed mount mode of 0700
> wouldn't break anything.

The summary is this:
 - debugfs has been demonstrably dangerous to have available
 - Alan Cox says that debugfs should not be used on production systems
 - Greg KH does not disagree
 - however, pref needs it, and this is used by some root users
 - perf will likely move out of debugfs as some point

What is the objection, then, to making the root of debugfs mode 0600? All
the tools I reviewed that need it run as root (e.g. powertop). I've
already written, tested, and sent the patches -- they would not break
the requirements above.

-Kees

-- 
Kees Cook
Ubuntu Security Team
