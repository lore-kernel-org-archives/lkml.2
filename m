Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab0D0T70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:59:26 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50459 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab0D0T7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:59:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZqTyrKJpQt+AKNK4UB5tON8TzFp4dTmJDRnNuHZYsnh3KOuNPivxyWqUNyF5TqJS+2
         f9Ztlhxg2TS0PIZC6+CtfqIcPSt3LiZF57b2FZ3GKxLJSCKO+PZNasfgSBsbTsYHsNkW
         pP+gT58P2pytlNL0RJjXUhVnZ0kZjxEC8sATE=
Date: Tue, 27 Apr 2010 21:59:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Subject: Re: [PATCH 1/7] logfs: push down BKL into ioctl function
Message-ID: <20100427195912.GD5586@nowhere>
References: <alpine.LFD.2.00.1004271359180.3318@localhost> <1272378265-10909-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272378265-10909-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 04:24:19PM +0200, Arnd Bergmann wrote:
> --- a/fs/smbfs/ioctl.c
> +++ b/fs/smbfs/ioctl.c
> @@ -26,7 +26,7 @@ int
>  smb_ioctl(struct inode *inode, struct file *filp,
>  	  unsigned int cmd, unsigned long arg)
>  {
> -	struct smb_sb_info *server = server_from_inode(inode);
> +	struct smb_sb_info *server = server_from_inode(filp->f_path.dentry->d_inode);
>  	struct smb_conn_opt opt;
>  	int result = -EINVAL;


I've included this part in the smbfs pushdown patch.

Thanks.

