Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab1BVT0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:26:04 -0500
Received: from smtp.outflux.net ([198.145.64.163]:45911 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab1BVT0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:26:01 -0500
Date: Tue, 22 Feb 2011 11:25:33 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Greg KH <gregkh@suse.de>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <20110222192532.GY4000@outflux.net>
References: <1298398198-18482-1-git-send-email-kees.cook@canonical.com>
 <1298398198-18482-2-git-send-email-kees.cook@canonical.com>
 <20110222181613.GU4000@outflux.net>
 <4D640133.9020901@caviumnetworks.com>
 <20110222184726.GV4000@outflux.net>
 <20110222191454.GB9991@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222191454.GB9991@suse.de>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, Feb 22, 2011 at 11:14:54AM -0800, Greg KH wrote:
> On Tue, Feb 22, 2011 at 10:47:26AM -0800, Kees Cook wrote:
> > On Tue, Feb 22, 2011 at 10:32:19AM -0800, David Daney wrote:
> > > On 02/22/2011 10:16 AM, Kees Cook wrote:
> > > >Har har, I forgot --compose to "git send-email".
> > > >
> > > >Anyway, with the continuing deluge of bugs in the "debug" filesystem, I
> > > >would like to make that filesystem's root directory mode 0700 by default
> > > >since it's filled with crazy stuff that regular users do not need to see.
> > > >
> > > >Better to try to just close the door completely on all the stuff in there.
> > > >It is, after all, supposed to only be used for debugging, right?
> > > >
> > > 
> > > It depends if you consider use of ftrace and kprobes 'debugging'.
> > > In any event, you really have to be root to be able to manipulate
> > > them.
> > > 
> > > I can currently do 'cat /sys/kernel/debug/tracing/trace' as a normal
> > > user.  With your change I don't think it would be possible.  This is
> > > not something I often (ever) do, but it is a change.
> > 
> > Right, my thinking is that all the manipulations on this tree should be
> > root-only (non-root stuff shouldn't live in something named "debug"),
> > so we might as well lock it down a bit more so we can avoid all the CVEs[1]
> > being assigned for glitches in this tree.
> 
> The CVEs are for non-root writes to debugfs, same thing for sysfs.  It's
> just stupid mistakes being made here, don't try to lock down the whole
> filesystem for just a handfull of bugs.
> 
> So I really can't accept these patches, sorry.

What system do you proposed to keep these "stupid mistakes" from
continuing to happen? If debugfs had already been mode 0700, we could have
avoided all of these CVEs, including the full-blown local root escalation.

The "no rules" approach to debugfs is not a good idea, IMO.

-Kees

-- 
Kees Cook
Ubuntu Security Team
