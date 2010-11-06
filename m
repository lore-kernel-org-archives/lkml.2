Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0KFSaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:30:22 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47858 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab0KFSaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:30:20 -0400
Date: Sat, 6 Nov 2010 11:28:52 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Siarhei Liakh <sliakh.lkml@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Subject: RO/NX protection for loadable kernel modules
Message-ID: <20101106182852.GC5327@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, anyone? What is the state of this? I can see it in the tip tree,
but it doesn't appear associated with a branch. What will it take to
get this into Linus's tree?

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=65187d24fa3ef60f691f847c792e8eaca7e19251

This feature is needed before the function-pointer const-ification patches
will really have any meaning.

Thanks,

-Kees

On Tue, Oct 19, 2010 at 09:45:39PM -0700, Kees Cook wrote:
> On Mon, Feb 08, 2010 at 11:59:44AM +1030, Rusty Russell wrote:
> > On Tue, 2 Feb 2010 04:36:49 pm H. Peter Anvin wrote:
> > > On 02/01/2010 07:59 PM, Rusty Russell wrote:
> > > > On Tue, 2 Feb 2010 10:09:53 am Siarhei Liakh wrote:
> > > >> This patch is a logical extension of the protection provided by
> > > >> CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
> > > >> module_core and module_init into three logical parts each and setting
> > > >> appropriate page access permissions for each individual section:
> > > >>
> > > >>   1. Code: RO+X
> > > >>   2. RO data: RO+NX
> > > >>   3. RW data: RW+NX
> > > >
> > > > Thanks, applied!
> > > 
> > > I also applied this to the -tip tree... do you prefer to carry it or 
> > > should I leave it as is?
> > 
> > I'm always happy for you to do my work for me!  There are no other module
> > patches likely to conflict.
> > 
> > Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Sorry for losing track, but where did this patch end up? I don't see it
> in any of the trees I've looked in.

-- 
Kees Cook
Ubuntu Security Team
