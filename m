Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1BVSsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:48:01 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34679 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab1BVSsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:48:00 -0500
Date: Tue, 22 Feb 2011 10:47:26 -0800
From: Kees Cook <kees.cook@canonical.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, Eugene Teo <eugeneteo@kernel.sg>,
        Ralph Campbell <infinipath@qlogic.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
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
Message-ID: <20110222184726.GV4000@outflux.net>
References: <1298398198-18482-1-git-send-email-kees.cook@canonical.com>
 <1298398198-18482-2-git-send-email-kees.cook@canonical.com>
 <20110222181613.GU4000@outflux.net>
 <4D640133.9020901@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D640133.9020901@caviumnetworks.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 10:32:19AM -0800, David Daney wrote:
> On 02/22/2011 10:16 AM, Kees Cook wrote:
> >Har har, I forgot --compose to "git send-email".
> >
> >Anyway, with the continuing deluge of bugs in the "debug" filesystem, I
> >would like to make that filesystem's root directory mode 0700 by default
> >since it's filled with crazy stuff that regular users do not need to see.
> >
> >Better to try to just close the door completely on all the stuff in there.
> >It is, after all, supposed to only be used for debugging, right?
> >
> 
> It depends if you consider use of ftrace and kprobes 'debugging'.
> In any event, you really have to be root to be able to manipulate
> them.
> 
> I can currently do 'cat /sys/kernel/debug/tracing/trace' as a normal
> user.  With your change I don't think it would be possible.  This is
> not something I often (ever) do, but it is a change.

Right, my thinking is that all the manipulations on this tree should be
root-only (non-root stuff shouldn't live in something named "debug"),
so we might as well lock it down a bit more so we can avoid all the CVEs[1]
being assigned for glitches in this tree.

-Kees

[1] http://seclists.org/oss-sec/2011/q1/229
    http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2010-4347
    etc

-- 
Kees Cook
Ubuntu Security Team
