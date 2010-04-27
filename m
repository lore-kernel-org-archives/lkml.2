Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab0D0OdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 10:33:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50065 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab0D0OdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 10:33:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 1/7] logfs: push down BKL into ioctl function
Date: Tue, 27 Apr 2010 16:32:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
References: <alpine.LFD.2.00.1004271359180.3318@localhost> <1272378265-10909-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1272378265-10909-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004271632.47819.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18layMGJ/uq17m1cYdNdhivoqmabEIyqzvssuI
 lTjktxcpk3V8UkNLj0wuOHxyXhfB578oCSrHWapfxCZXKkD5PI
 B/EZM5vO4mPG8MEH9GmLQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 April 2010, Arnd Bergmann wrote:
> diff --git a/fs/smbfs/ioctl.c b/fs/smbfs/ioctl.c
> index dbae1f8..910215b 100644
> --- a/fs/smbfs/ioctl.c
> +++ b/fs/smbfs/ioctl.c
> @@ -26,7 +26,7 @@ int
>  smb_ioctl(struct inode *inode, struct file *filp,
>           unsigned int cmd, unsigned long arg)
>  {
> -       struct smb_sb_info *server = server_from_inode(inode);
> +       struct smb_sb_info *server = server_from_inode(filp->f_path.dentry->d_inode);
>         struct smb_conn_opt opt;
>         int result = -EINVAL;

This hunk obviously belongs to the smbfs patch, not the logfs patch. Sorry about that.

	Arnd
