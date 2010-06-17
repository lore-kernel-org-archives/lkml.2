Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084Ab0FQNqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 09:46:37 -0400
Received: from tundra.namei.org ([65.99.196.166]:38572 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759932Ab0FQNqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 09:46:34 -0400
Date: Thu, 17 Jun 2010 23:45:42 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <kees.cook@canonical.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
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
In-Reply-To: <20100616232230.GP24749@outflux.net>
Message-ID: <alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>
References: <20100616221833.GM24749@outflux.net> <20100617000120.13071be8@lxorguk.ukuu.org.uk> <20100616232230.GP24749@outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010, Kees Cook wrote:

[Note: it would be useful to cc: the LSM list on security discussions]

> Certainly.  PTRACE can already be confined by SELinux and AppArmor.  I'm
> looking for a general approach that doesn't require a system builder to
> create MAC policies for unknown software.  I want to define a common core
> behavior.
> 
> > And even if you don't care about using the same security stuff the rest
> > of the world is using to solve the problem this like the other half baked
> > stuff you posted for links belongs as a security module.
> 
> The LSM isn't stackable, so I can't put it there and choose this and
> SELinux (for the case of software-without-a-policy).

SELinux already supports a global switch for ptrace via the allow_ptrace 
boolean.  You don't need to write any policy, just set it to 0.

Global behavior can be further customized and refined (e.g. create a 
generic policy module for apps without an existing policy, which allows 
everything except things like ptrace and dangerous symlinks).

SELinux users would not need the other LSM, and stacking is thus not 
required.


- James
-- 
James Morris
<jmorris@namei.org>
