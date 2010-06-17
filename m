Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab0FQRGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:06:20 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45008 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756914Ab0FQRGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:06:18 -0400
Date: Thu, 17 Jun 2010 10:04:53 -0700
From: Kees Cook <kees.cook@canonical.com>
To: James Morris <jmorris@namei.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
Message-ID: <20100617170453.GV24749@outflux.net>
References: <20100616221833.GM24749@outflux.net>
 <20100617000120.13071be8@lxorguk.ukuu.org.uk>
 <20100616232230.GP24749@outflux.net>
 <alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Thu, Jun 17, 2010 at 11:45:42PM +1000, James Morris wrote:
> On Wed, 16 Jun 2010, Kees Cook wrote:
> 
> [Note: it would be useful to cc: the LSM list on security discussions]

Sorry, I was blindly using get_maintainer output.

> > Certainly.  PTRACE can already be confined by SELinux and AppArmor.  I'm
> > looking for a general approach that doesn't require a system builder to
> > create MAC policies for unknown software.  I want to define a common core
> > behavior.
> > 
> > > And even if you don't care about using the same security stuff the rest
> > > of the world is using to solve the problem this like the other half baked
> > > stuff you posted for links belongs as a security module.
> > 
> > The LSM isn't stackable, so I can't put it there and choose this and
> > SELinux (for the case of software-without-a-policy).
> 
> SELinux already supports a global switch for ptrace via the allow_ptrace 
> boolean.  You don't need to write any policy, just set it to 0.
> 
> Global behavior can be further customized and refined (e.g. create a 
> generic policy module for apps without an existing policy, which allows 
> everything except things like ptrace and dangerous symlinks).
> 
> SELinux users would not need the other LSM, and stacking is thus not 
> required.

But if a user wants to disable ptrace using the SELinux LSM and then
also disable sticky-symlinks via the ItsHideous LSM, they're out of luck.

-Kees

-- 
Kees Cook
Ubuntu Security Team
