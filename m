Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab1BVSQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:16:50 -0500
Received: from smtp.outflux.net ([198.145.64.163]:40312 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024Ab1BVSQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:16:49 -0500
Date: Tue, 22 Feb 2011 10:16:13 -0800
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Eugene Teo <eugeneteo@kernel.sg>, Ralph Campbell <infinipath@qlogic.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, James Morris <jmorris@namei.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, Nick Piggin <npiggin@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ian.campbell@citrix.com>,
        Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>,
        Tejun Heo <tj@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] debugfs: only allow root access to debugging
 interfaces
Message-ID: <20110222181613.GU4000@outflux.net>
References: <1298398198-18482-1-git-send-email-kees.cook@canonical.com>
 <1298398198-18482-2-git-send-email-kees.cook@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298398198-18482-2-git-send-email-kees.cook@canonical.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Har har, I forgot --compose to "git send-email".

Anyway, with the continuing deluge of bugs in the "debug" filesystem, I
would like to make that filesystem's root directory mode 0700 by default
since it's filled with crazy stuff that regular users do not need to see.

Better to try to just close the door completely on all the stuff in there.
It is, after all, supposed to only be used for debugging, right?

-Kees

On Tue, Feb 22, 2011 at 10:09:58AM -0800, Kees Cook wrote:
> Block access to the potentially dangerous debugging interfaces in
> the debugfs filesystem.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
>  fs/debugfs/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> index 3cb33c3..83c61a3 100644
> --- a/fs/debugfs/inode.c
> +++ b/fs/debugfs/inode.c
> @@ -133,7 +133,7 @@ static int debug_fill_super(struct super_block *sb, void *data, int silent)
>  	static struct tree_descr debug_files[] = {{""}};
>  
>  	return simple_fill_super(sb, DEBUGFS_MAGIC, debug_files,
> -				 S_IWUSR | S_IRUGO | S_IXUGO);
> +				 S_IRWXU);
>  }
>  
>  static struct dentry *debug_mount(struct file_system_type *fs_type,
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Kees Cook
Ubuntu Security Team
