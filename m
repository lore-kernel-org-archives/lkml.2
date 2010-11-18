Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab0KRUJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:09:17 -0500
Received: from smtp.outflux.net ([198.145.64.163]:58415 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab0KRUJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:09:16 -0500
Date: Thu, 18 Nov 2010 12:08:38 -0800
From: Kees Cook <kees.cook@canonical.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, torvalds@linux-foundation.org,
        joe@perches.com, drosenberg@vsecurity.com, mingo@elte.hu,
        eugeneteo@kernel.org, akpm@linux-foundation.org, jmorris@namei.org,
        morgan@kernel.org, casey@schaufler-ca.com
Subject: Re: [PATCH] capabilities/syslog: open code cap_syslog logic to fix
 build failure
Message-ID: <20101118200838.GH13854@outflux.net>
References: <20101115233628.6288.2303.stgit@paris.rdu.redhat.com>
 <20101118142624.GA927@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118142624.GA927@hallyn.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,

On Thu, Nov 18, 2010 at 08:26:24AM -0600, Serge E. Hallyn wrote:
> Quoting Eric Paris (eparis@redhat.com):
> > @@ -274,7 +274,20 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
> >  	char c;
> >  	int error = 0;
> >  
> > -	error = security_syslog(type, from_file);
> > +	/*
> > +	 * If this is from /proc/kmsg we only do the capabilities checks
> > +	 * at open time.
> > +	 */
> > +	if (type == SYSLOG_ACTION_OPEN || !from_file) {
> > +		if (dmesg_restrict && !capable(CAP_SYS_ADMIN))
> 
> Any chance we could introduce a new capability for this?

Wasn't there talk of creating CAP_SYSLOG or something? Right now most
sysklogd implementations are just starting life as root, so making this
change now shouldn't break anyone.

-Kees

-- 
Kees Cook
Ubuntu Security Team
