Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab0D3SrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:47:13 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43132 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab0D3Sqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=oj6tAjPkW93CWKzp9fmpv/jhk3/brPNBO3hT0oNryn3giIzqHNEaIYoRuK8MEE19YW
         MGOAW/WUljF90Q7p9auIKt3uAZdt6rgDk5paE9HEvw/qAJjd/NViNZUqO3Qg0Ous3O/w
         cAsMIBti2gYs8DklJAw4Z/gnbtAtPG/5YY/n8=
Date: Thu, 29 Apr 2010 22:50:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: build failure after merge of the bkl-ioctl tree
Message-ID: <20100429205026.GB5392@nowhere>
References: <20100429154947.fbacee1f.sfr@canb.auug.org.au> <alpine.LFD.2.00.1004292239320.8472@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1004292239320.8472@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 10:40:56PM +0200, John Kacur wrote:
> 
> 
> On Thu, 29 Apr 2010, Stephen Rothwell wrote:
> 
> > Hi Frédéric,
> > 
> > After merging the bkl-ioctl tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > drivers/scsi/3w-xxxx.c: In function 'tw_chrdev_ioctl':
> > drivers/scsi/3w-xxxx.c:896: error: 'inode' undeclared (first use in this function)
> > 
> > Caused by commit 5c9af160f830a68734f600fc0f90cba35e26727b ("scsi: Push
> > down BKL into ioctl functions").
> > 
> > I have used the version of the blk-ioctl tree from next-20100428 for
> > today.
> 
> Frederic: did you miss one of my patches to fix the scsi compile problems?
> 
> The following should have fixed the above:
> 
> From 3605ca2d1b29511fe1c95b47c4c596f392797585 Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Tue, 27 Apr 2010 10:47:43 +0200
> Subject: [PATCH 04/10] bkl: Fix missing inode tw_chrdev_ioctl due to bkl pushdown
> Cc: Arnd Bergmann <arnd@arndb.de>,
>     Linus Torvalds <torvalds@linux-foundation.org>,
>     Frederic Weisbecker <fweisbec@gmail.com>,
>     Jan Blunck <jblunck@gmail.com>,
>     Thomas Gleixner <tglx@linutronix.de>
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  drivers/scsi/3w-xxxx.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> index 45a737c..2957691 100644
> --- a/drivers/scsi/3w-xxxx.c
> +++ b/drivers/scsi/3w-xxxx.c
> @@ -890,6 +890,7 @@ static long tw_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long a
>  	unsigned long data_buffer_length_adjusted = 0;
>  	unsigned long *cpu_addr;
>  	long timeout;
> +	struct inode *inode = file->f_dentry->d_inode;
>  	TW_New_Ioctl *tw_ioctl;
>  	TW_Passthru *passthru;
>  	TW_Device_Extension *tw_dev = tw_device_extension_list[iminor(inode)];
> -- 
> 1.6.6.1



My bad, I was really sure I integrated all of your fixes, and it even fixed
by build. I probably forgot a git-add.

Will apply this one, thanks!

