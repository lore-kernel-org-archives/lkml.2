Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab0FAL5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 07:57:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab0FAL5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 07:57:15 -0400
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
From: Eric Paris <eparis@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Kees Cook <kees.cook@canonical.com>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <20100601075529.GA11397@infradead.org>
References: <20100531030402.GQ6056@outflux.net>
	 <20100531103510.GA30021@infradead.org> <20100531175733.GD4098@outflux.net>
	 <alpine.LRH.2.00.1006010904190.675@tundra.namei.org>
	 <20100601032423.GL4098@outflux.net>  <20100601075529.GA11397@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 07:55:02 -0400
Message-ID: <1275393302.2690.13.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 03:55 -0400, Christoph Hellwig wrote:
> On Mon, May 31, 2010 at 08:24:23PM -0700, Kees Cook wrote:

> > My rationale is that if it's in commoncaps, it's effective for everyone, so
> > it might as well be in core VFS.  If the VFS objections really do boil down
> > to "not in fs/" then I'm curious if doing this in commoncaps is acceptable.
> 
> If you think the objection is about having things in fs/ you're smoking
> some really bad stuff.

Sounds to me like we should probably follow the same path as
mmap_min_addr.  We should add these hooks right in the VFS where they
belong (much like mmap_min_addr hooks into the vm) and control them 2
ways.

1) a Kconfig so distros can choose to turn it on or off by default
2) a /proc interface so root can turn it off

Nothing about that precludes additional similar checks inside an LSM
(like CONFIG_LSM_MMAP_MIN_ADDR) which can be more finely controlled.  So
maybe we want to follow up with the core VFS check with new checks in
SELinux (and maybe apparmour).  This allows the user to disable the
general check and still be provided with some modicum of protection.
You might ask why not ONLY do the check in SELinux and drop the generic
check, but we have seen with mmap_min_addr that the SELinux unconfined
user can do damn well anything it wants to, so having a non-LSM version
of appropriate security checks is highly regarded.

(see eparis.livejournal.com for a long discussion on the LSM creating a
weaker machine in some cases when there are no non-LSM checks)

-Eric

