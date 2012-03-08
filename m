Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab2CHW2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:28:49 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59769 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758752Ab2CHW2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:28:47 -0500
Date: Thu, 8 Mar 2012 14:28:43 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH 1/3] sysfs:  Compact sysfs_dirent s_flags into a byte.
Message-ID: <20120308222843.GB32001@kroah.com>
References: <4F27C6EB.2070305@suse.cz>
 <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org>
 <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
 <4F54BFEC.6000206@suse.cz>
 <20120305160953.GA3870@kroah.com>
 <m1r4x2wzdt.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r4x2wzdt.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 01:34:22PM -0800, Eric W. Biederman wrote:
> 
> In an effort to keep sysfs_dirent small used the smallest
> basic type I can for sysfs s_flags.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/sysfs/sysfs.h |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
> index 6289a00..c76c932 100644
> --- a/fs/sysfs/sysfs.h
> +++ b/fs/sysfs/sysfs.h
> @@ -76,7 +76,7 @@ struct sysfs_dirent {
>  		struct sysfs_elem_bin_attr	s_bin_attr;
>  	};
>  
> -	unsigned short		s_flags;
> +	unsigned char		s_flags;
>  	umode_t 		s_mode;
>  	unsigned int		s_ino;
>  	struct sysfs_inode_attrs *s_iattr;

Are you sure this saved you any real space here?  Have you use pahole (I
think that's the tool name) to determine if there are holes in the
structure?  Given that you moved this to a smaller variable, yet there
are pointers later on, odds are nothing changed at all overall.

Verification would be good to have, to see if this work was really worth
it, right?

thanks,

greg k-h
