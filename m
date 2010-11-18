Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab0KRWWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:22:09 -0500
Received: from adelie.canonical.com ([91.189.90.139]:50501 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab0KRWWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:22:07 -0500
Date: Thu, 18 Nov 2010 16:21:57 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, torvalds@linux-foundation.org,
        joe@perches.com, drosenberg@vsecurity.com, mingo@elte.hu,
        eugeneteo@kernel.org, akpm@linux-foundation.org, jmorris@namei.org,
        morgan@kernel.org, casey@schaufler-ca.com
Subject: Re: [PATCH] capabilities/syslog: open code cap_syslog logic to fix
 build failure
Message-ID: <20101118222157.GA8599@hallyn.com>
References: <20101115233628.6288.2303.stgit@paris.rdu.redhat.com>
 <20101118142624.GA927@hallyn.com>
 <20101118200838.GH13854@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118200838.GH13854@outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (kees.cook@canonical.com):
> Hi Serge,
> 
> On Thu, Nov 18, 2010 at 08:26:24AM -0600, Serge E. Hallyn wrote:
> > Quoting Eric Paris (eparis@redhat.com):
> > > @@ -274,7 +274,20 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
> > >  	char c;
> > >  	int error = 0;
> > >  
> > > -	error = security_syslog(type, from_file);
> > > +	/*
> > > +	 * If this is from /proc/kmsg we only do the capabilities checks
> > > +	 * at open time.
> > > +	 */
> > > +	if (type == SYSLOG_ACTION_OPEN || !from_file) {
> > > +		if (dmesg_restrict && !capable(CAP_SYS_ADMIN))
> > 
> > Any chance we could introduce a new capability for this?
> 
> Wasn't there talk of creating CAP_SYSLOG or something? Right now most
> sysklogd implementations are just starting life as root, so making this
> change now shouldn't break anyone.

Uh, huh.  I guess the last it was discussed was in March,
http://thread.gmane.org/gmane.linux.kernel.lsm/10615 .  I
think not enough people argued about it so it slipped my
mind :)  We need someone to flame to drive continued discussion :)

-serge
