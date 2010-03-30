Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0C3GqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:46:23 -0400
Received: from mail-pz0-f173.google.com ([209.85.222.173]:41739 "EHLO
	mail-pz0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab0C3GqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:46:21 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Mar 2010 02:46:20 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gclf3mu4elJObKNzqEXLphkxNDd/XLwqhYAMY70nATikPWxs9dCD7GtfqxrIavsJHE
         CutpgNxWyj3p8Af0Nv6YLhQwDC4oeeCUp6EnbYy9FHdQBfJxQ0MRAO3L20NQfv5Snomv
         +V0DPtrN34qMaHC+45pvQmpQs0HvuS2VDPkT4=
MIME-Version: 1.0
In-Reply-To: <1269930015-863-7-git-send-regression-fweisbec@gmail.com>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
	 <1269930015-863-7-git-send-regression-fweisbec@gmail.com>
Date: Tue, 30 Mar 2010 09:38:11 +0300
Message-ID: <b6fcc0a1003292338yafeb3d3k37fb3fa79af5340c@mail.gmail.com>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 9:20 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -231,9 +231,9 @@ static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigne
>                if (rv == -ENOIOCTLCMD)
>                        rv = -EINVAL;
>        } else if (ioctl) {
> -               lock_kernel();
> +               WARN_ONCE(1, "Procfs ioctl handlers must use unlocked_ioctl, "
> +                         "%pf will be called without the Bkl held\n", ioctl);
>                rv = ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
> -               unlock_kernel();

Then delete the branch.
Or go through formal feature-removal procedure.
