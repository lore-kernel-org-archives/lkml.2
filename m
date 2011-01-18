Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1ARXJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 18:09:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52264 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab1ARXJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 18:09:41 -0500
Date: Tue, 18 Jan 2011 23:09:36 +0000
From: Joel Becker <jlbec@evilplan.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] ocfs2: Make OCFS2_FS depend on CONFIGFS_FS
Message-ID: <20110118230936.GD13251@ZenIV.linux.org.uk>
Mail-Followup-To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	James Bottomley <James.Bottomley@suse.de>
References: <1295133371-25990-1-git-send-email-nab@linux-iscsi.org>
 <1295133371-25990-4-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295133371-25990-4-git-send-email-nab@linux-iscsi.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 03:16:10PM -0800, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch fixes the following kconfig error after changing
> CONFIGFS_FS -> select SYSFS:
> 
> fs/sysfs/Kconfig:1:error: recursive dependency detected!
> fs/sysfs/Kconfig:1:	symbol SYSFS is selected by CONFIGFS_FS
> fs/configfs/Kconfig:1:	symbol CONFIGFS_FS is selected by OCFS2_FS
> fs/ocfs2/Kconfig:1:	symbol OCFS2_FS depends on SYSFS

<snip>

> diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
> index ab152c0..77a8de5 100644
> --- a/fs/ocfs2/Kconfig
> +++ b/fs/ocfs2/Kconfig
> @@ -1,7 +1,6 @@
>  config OCFS2_FS
>  	tristate "OCFS2 file system support"
> -	depends on NET && SYSFS
> -	select CONFIGFS_FS
> +	depends on NET && SYSFS && CONFIGFS_FS

	Isn't this exactly what Linus just said not to do?  I don't want
to know that I need to select configfs.  Shouldn't it instead just be:

	select NET
	select CONFIGFS_FS

Linus?

Joel

-- 
