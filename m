Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab2JLNZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:25:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59494 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab2JLNZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:25:49 -0400
Message-ID: <50781A58.4060403@canonical.com>
Date: Fri, 12 Oct 2012 15:25:44 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: al viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "__d_unalias() should refuse to move mountpoints"
References: <50609C43.1070702@canonical.com> <87txumrct6.fsf@xmission.com> <50615268.1040805@canonical.com> <8db34325-e8e4-4e24-85dd-c8951769e2b6@email.android.com> <506173A6.2050705@canonical.com> <87ipb2pemt.fsf@xmission.com> <50618F96.1020204@canonical.com> <87sja6nxvt.fsf@xmission.com>
In-Reply-To: <87sja6nxvt.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 25-09-12 13:29, Eric W. Biederman schreef:
> Maarten Lankhorst <maarten.lankhorst@canonical.com> writes:
>
>>> Could you try the following patch?  This should report what directories
>>> cannot be renamed because one of them is a mount point and it gives some
>>> real insight into what is going on.
>> ls /
>> __d_unalias: /dev -> /dev
>> __d_unalias: /proc -> /proc
>> __d_unalias: /sys -> /sys
> Ok.  That is what I thought was going on.  For some reason nfs is
> attempting to recreate an existing dentry.
>
> Does this fix the nfs problem for you?
>
> Eric
>
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 8086636..6390f0f 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2404,6 +2404,9 @@ out_unalias:
>  	if (likely(!d_mountpoint(alias))) {
>  		__d_move(alias, dentry);
>  		ret = alias;
> +	} else if ((alias->d_parent == dentry->d_parent) &&
> +		   !dentry_cmp(alias, dentry->d_name.name, dentry->d_name.len))
> +		ret = alias;
>  	}
>  out_err:
>  	spin_unlock(&inode->i_lock);
>
>
Are you going to send this in? I don't see a fix for this in linus' kernel yet.

Reported-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Tested-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

~Maarten
