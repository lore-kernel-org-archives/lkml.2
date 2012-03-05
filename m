Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab2CEM6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 07:58:36 -0500
Received: from 1wt.eu ([62.212.114.60]:62849 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756965Ab2CEM6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 07:58:35 -0500
Date: Mon, 5 Mar 2012 13:54:59 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Tony Luck <tony.luck@intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        raven@themaw.net
Subject: Re: Build broken on s390 and ia64 [was: Linux 2.6.32.58]
Message-ID: <20120305125459.GF30594@1wt.eu>
References: <20120304180911.GA7336@kroah.com> <4F54A46A.6000305@suse.cz> <20120305120241.GA3627@osiris.boeblingen.de.ibm.com> <4F54B618.1090301@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F54B618.1090301@suse.cz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 01:48:24PM +0100, Jiri Slaby wrote:
> On 03/05/2012 01:02 PM, Heiko Carstens wrote:
> > On Mon, Mar 05, 2012 at 12:32:58PM +0100, Jiri Slaby wrote:
> >> Perhaps asm/compat.h should be included from linux/compat.h
> >> unconditionally...
> > 
> > If you do that you need to add #ifdef wrappers around the is_compat_task()
> > definitions in each arch that supports CONFIG_COMPAT. If that's all that's
> > needed that would be great!
> 
> I don't know, I haven't checked. It was just a shot in the dark. Maybe
> it's easier to revert the removal of asm/compat.h from s390 files. Could
> you bake a patch?
> 
> >>> Linus Torvalds (2): Fix autofs compile without CONFIG_COMPAT
> >>
> >> But who defines is_compat_task *with* CONFIG_COMPAT on ia64?
> >>
> >> fs/autofs4/inode.c: In function 'autofs4_fill_super':
> >> fs/autofs4/inode.c:345: error: implicit declaration of function
> >> 'is_compat_task'
> > 
> > The ia64 compat code got entirely removed, since it was broken:
> > 
> > 32974ad4907cdde6c9de612cd1b2ee0568fb9409 "[IA64] Remove COMPAT_IA32 support"
> 
> Yes, but that is even in 2.6.34. So the fix for autofs is incomplete in
> .32 as it breaks build on configs which used to work.

I'm open to releasing .59 to fix these two issues once patches are
ready or identified. Does anybody know if other archs were broken ?

Thanks,
Willy

