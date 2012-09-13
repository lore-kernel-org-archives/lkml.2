Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab2IMQi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 12:38:56 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56075 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758253Ab2IMQiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 12:38:54 -0400
Date: Thu, 13 Sep 2012 20:38:48 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 2/2] checksyscalls: ignore kcmp system call
Message-ID: <20120913163848.GM19956@moon>
References: <1347017491-11354-1-git-send-email-heiko.carstens@de.ibm.com>
 <1347017491-11354-2-git-send-email-heiko.carstens@de.ibm.com>
 <20120907120234.GB2121@moon>
 <20120913160237.GA10145@osiris.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913160237.GA10145@osiris.de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 06:02:37PM +0200, Heiko Carstens wrote:
> On Fri, Sep 07, 2012 at 04:02:34PM +0400, Cyrill Gorcunov wrote:
> > On Fri, Sep 07, 2012 at 01:31:31PM +0200, Heiko Carstens wrote:
> > > Now that the checksyscalls script works again it will warn about the missing
> > > "kcmp" system call on all architectures but x86.
> > > Since according to git commit d97b46a6 "syscalls, x86: add __NR_kcmp syscall"
> > > only x86 is currently supported don't emit any warning for this system call.
> [...]
> > > diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
> > > index fd8fa9a..c7cda79 100755
> > > --- a/scripts/checksyscalls.sh
> > > +++ b/scripts/checksyscalls.sh
> > > @@ -194,6 +194,9 @@ cat << EOF
> > >  #define __IGNORE_getpmsg
> > >  #define __IGNORE_putpmsg
> > >  #define __IGNORE_vserver
> > > +
> > > +/* kcmp is currently x86 only */
> > > +#define __IGNORE_kcmp
> 
> Ok, I wired the system call up on s390 and the test case passed.
> Below is the patch that is needed to actually reach the system call from
> other architectures than x86.
> Andrew, can you pick this one up as well?
> 
> The code that wires the system call up on s390 will go upstream via the
> s390 tree. Thanks to kcmp being a cond_syscall there is no compile
> time dependency.
> 
> From 1ff800597ea8f678a179387e3cf2ae663531e2fe Mon Sep 17 00:00:00 2001
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date: Thu, 13 Sep 2012 09:37:38 +0200
> Subject: [PATCH] syscalls: make kcmp syscall available for all architectures
> 
> Remove the x86 dependency, since the system call is not
> architecture dependend.
> 
> Also add a ptrace.h include, so it compiles at least also on s390.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>

Thanks a lot!
