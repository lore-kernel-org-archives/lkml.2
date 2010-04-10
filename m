Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab0DJN1g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 09:27:36 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33209 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0DJN1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 09:27:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qHXeAus4qfv97zsCE9zNHxBmQXi9Pxu5yxKRqZ2iLctAd2NTyLPPvNUPd6VD0+7yfS
         Y8wA8Shnoaxdj3Vf5cbBhfhcfPZKJBXTzhSHaCjtNJVRYhiaIgH+XHldFP9SQCtDa1Yp
         MQUksOLzEaQADFtK2CbitxcX4s7lizvFzaT5Y=
Date: Sat, 10 Apr 2010 15:27:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/6] Kill the bkl in procfs
Message-ID: <20100410132725.GB5204@nowhere>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 08:20:09AM +0200, Frederic Weisbecker wrote:
> Hi,
> 
> This patchset drops any use of the big kernel lock from procfs.
> May be there is still one or two NULL llseek somewhere but I
> think we have fixed 99% of those that were in the procfs core.
> 
> Users of procfs implementing an ioctl have not been easy to
> spot automatically (there are hundreds of procfs users)
> as there are many indirect ways to register a procfs, depending
> on the subsystem you are.
> 
> So for those who want to verify the reliability of this check,
> you can look at the script there:
> 
> 	http://tglx.de/~fweisbec/seek.py
> 
> Beware it's very dirty! The hardcoded path are those I had
> to check manually (or that I added to the automatic check).
> One day I should learn how to use Coccinelle instead.
> 
> In the worst case, the remaining ones this script or my eyes
> forgot will trigger a warning.
> 
> Thanks.


I've applied the patchset to

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	bkl/procfs

Thanks.




> 
> 
> Arnd Bergmann (1):
>   procfs: Kill BKL in llseek on proc base
> 
> Frederic Weisbecker (5):
>   procfs: Use generic_file_llseek in /proc/kcore
>   procfs: Use generic_file_llseek in /proc/kmsg
>   procfs: Use generic_file_llseek in /proc/vmcore
>   procfs: Push down the bkl from ioctl
>   procfs: Kill the bkl in ioctl
> 
>  drivers/char/i8k.c                  |   53 +++++++++++++++------
>  drivers/isdn/divert/divert_procfs.c |   90 ++++++++++++++++++++++-------------
>  fs/proc/base.c                      |   10 ++++-
>  fs/proc/inode.c                     |    4 +-
>  fs/proc/kcore.c                     |    1 +
>  fs/proc/kmsg.c                      |    1 +
>  fs/proc/vmcore.c                    |    1 +
>  net/sunrpc/cache.c                  |   20 ++++++--
>  8 files changed, 123 insertions(+), 57 deletions(-)
> 

