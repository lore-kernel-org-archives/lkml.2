Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030313Ab2EPLi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:38:59 -0400
Received: from tundra.namei.org ([65.99.196.166]:35127 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030287Ab2EPLii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:38:38 -0400
Date: Wed, 16 May 2012 21:38:30 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Al Viro <viro@zeniv.linux.org.uk>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@us.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
In-Reply-To: <alpine.LRH.2.02.1205162135320.10697@tundra.namei.org>
Message-ID: <alpine.LRH.2.02.1205162138160.10697@tundra.namei.org>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com> <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com> <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com> <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
 <1337112446.20904.50.camel@falcor> <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com> <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com> <20120516004251.GO22082@ZenIV.linux.org.uk> <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
 <CA+55aFy1qQkGXAr=0Zqk=qJeGTpfMOVC2=rdRWzQ1qsUZ5P0_g@mail.gmail.com> <alpine.LRH.2.02.1205162135320.10697@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012, James Morris wrote:

> On Tue, 15 May 2012, Linus Torvalds wrote:
> 
> > Hmm?
> 
> diff --git a/security/capability.c b/security/capability.c
> index 5bb21b1c448c..9a19c6a54e12 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -949,7 +949,6 @@ void __init security_fixup_ops(struct 
> security_operations *ops)
>         set_to_cap_if_null(ops, file_alloc_security);
>         set_to_cap_if_null(ops, file_free_security);
>         set_to_cap_if_null(ops, file_ioctl);
> -       set_to_cap_if_null(ops, file_mmap);
>         set_to_cap_if_null(ops, file_mprotect);
>         set_to_cap_if_null(ops, file_lock);
>         set_to_cap_if_null(ops, file_fcntl);
> 
> 
> Do we need to add addr_map to the fixup ops?

mmap_addr I mean.



-- 
James Morris
<jmorris@namei.org>
