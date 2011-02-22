Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab1BVTu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:50:58 -0500
Received: from smtp.outflux.net ([198.145.64.163]:40936 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab1BVTu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:50:57 -0500
Date: Tue, 22 Feb 2011 11:50:18 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>, David Daney <ddaney@caviumnetworks.com>,
        linux-kernel@vger.kernel.org, Eugene Teo <eugeneteo@kernel.sg>,
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
Message-ID: <20110222195018.GA4000@outflux.net>
References: <1298398198-18482-1-git-send-email-kees.cook@canonical.com>
 <1298398198-18482-2-git-send-email-kees.cook@canonical.com>
 <20110222181613.GU4000@outflux.net>
 <4D640133.9020901@caviumnetworks.com>
 <20110222184726.GV4000@outflux.net>
 <20110222191454.GB9991@suse.de>
 <20110222192532.GY4000@outflux.net>
 <20110222193418.773ccd4b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222193418.773ccd4b@lxorguk.ukuu.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 07:34:18PM +0000, Alan Cox wrote:
> > What system do you proposed to keep these "stupid mistakes" from
> > continuing to happen? If debugfs had already been mode 0700, we could have
> > avoided all of these CVEs, including the full-blown local root escalation.
> 
> And all sorts of features would have put themselves in sysfs instead and
> broken no doubt.
> 
> > The "no rules" approach to debugfs is not a good idea, IMO.
> 
> It's a debugging fs, it needs to be "no rules" other than the obvious
> "don't mount it on production systems"

Okay, so the debugfs is not supposed to be mounted on a production system.
This seems to be news to a lot of developers trying to use the interfaces
exposed there. It would be nice to say this more loudly.  Basically,
a normal system should not depend on anything in the debugfs. I can get
behind that.

> Or of course you could just chmod it 0700 in the distro !

I'm trying to, but that involves a race condition since I can't control it
during the mount (nor set the default mode like I was trying to with the
patchset). tmpfs allows "mode=", but debugfs does not...

-Kees

-- 
Kees Cook
Ubuntu Security Team
