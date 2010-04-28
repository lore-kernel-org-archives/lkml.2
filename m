Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab0D1VS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:18:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55647 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab0D1VS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:18:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MIfDF1dVd5cOKhjPuPReCB3lEVhdCEbaebGTH+xUs8uGTTJ63rOklrTTM/dLJ9rshb
         9p3Pz1liTG0MyKY7czzW8WDVfmpfVEgs1lOHo9yhSnQBaN8n5Eyyfd0c8+xHGOgC031o
         RUlj6LX0SQxCpKvw+lhU+dHeMIt7jgNUm1W24=
Date: Wed, 28 Apr 2010 23:18:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/10] bkl: pushdowns from Arnd, and compile fixes
Message-ID: <20100428211853.GB6037@nowhere>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 11:18:08AM +0200, John Kacur wrote:
> These are bkl pushdowns from Arnd that conflicted with
> Linus's "Preparation for BKL'ed ioctl removal patch". I fixed-up the merge
> conflicts. In addition - during allyesconfig compile testing on x86_64 I found
> a number of issues that I fixed-up
> 
> I pushed these to my own new linus-bkl tree.
> git://www.kernel.org/pub/scm/linux/kernel/git/jkacur/jk-2.6.git linux-bkl
> 
> Frederic, if you want to grab those, pls do so. also, we might want to combine
> my compile fixes with Arnd's push-down patches, for better git bisectability.
> 
> Presented separately here for everyone's easy perusal.
> 
> Arnd Bergmann (6):
>   dvb: push down BKL into ioctl functions
>   scsi: push down BKL into ioctl functions
>   isdn: push down BKL into ioctl functions
>   staging: push down BKL into ioctl functions
>   v4l: always use unlocked_ioctl
>   drivers: push down BKL into various drivers
> 
> John Kacur (4):
>   bkl: Fix up compile problems in megaraid from bkl push-down
>   bkl: Fix missing inode tw_chrdev_ioctl due to bkl pushdown
>   bkl: Fix missing inode in twl_chrdev_ioctl resulting from bkl
>     pushdown
>   bkl: Fix-up compile problems as a result of the bkl-pushdown.


Applied the series in bkl/ioctl, except the staging part that went
to Greg's tree and the v4l part for which Linus had concerns.

I haven't pushed your fixes separately but merged them into
the concerned arnd's patches with your SOB added.

It passed allyesconfig in sparc.

Thanks.

