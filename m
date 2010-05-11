Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab0EKHIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 03:08:16 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61141 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab0EKHIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 03:08:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i31An3Od5AyuwDc00dLiETMA4iU2c+z3+srn6U4xvHhDai7rB1XXOTedJTtxp4bI0Y
         yJW7NAF9ecZZLYGUK9MkF9MZqXqTb3dTnNIKw1f9d5eUbBkhsR7iXOqAfn6p0CrxVFgq
         MmJuXsJKNcG0G3lLYtvUwZIkgDz5UrYlrWAFY=
Date: Tue, 11 May 2010 09:08:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/6] BKL ioctl pushdown
Message-ID: <20100511070758.GF5468@nowhere>
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273065339-21669-1-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 03:15:33PM +0200, John Kacur wrote:
> These patches convert ioctls to unlocked_ioctls by pushing down the bkl into
> them. I had to go outside of the files that we agreed on, because logically the
> ioctls in each kind of file system belong together.
> 
> Frederic and Arnd, you can pull from:
> git.kernel.org//pub/scm/linux/kernel/git/jkacur/jk-2.6.git linus-bkl-pushdown



Thanks John.

I will apply the patches from this set that haven't been applied yet,
for .35



 
> John Kacur (6):
>   coda: BKL ioctl pushdown
>   coda: Clean-up whitespace problems in pioctl.c
>   fat: BKL ioctl pushdown
>   ncpfs: BKL ioctl pushdown
>   smbfs: BKL ioctl pushdown
>   udf: BKL ioctl pushdown
> 
>  fs/coda/pioctl.c       |   76 ++++++++++++++++++++++++++----------------------
>  fs/fat/dir.c           |   36 +++++++++++++++-------
>  fs/fat/fat.h           |    3 +-
>  fs/fat/file.c          |   22 ++++++++++----
>  fs/ncpfs/dir.c         |    2 +-
>  fs/ncpfs/file.c        |    2 +-
>  fs/ncpfs/ioctl.c       |   27 ++++++++++-------
>  fs/smbfs/dir.c         |    2 +-
>  fs/smbfs/file.c        |    2 +-
>  fs/smbfs/ioctl.c       |   10 ++++--
>  fs/smbfs/proto.h       |    2 +-
>  fs/udf/dir.c           |    2 +-
>  fs/udf/file.c          |   43 +++++++++++++++++----------
>  fs/udf/udfdecl.h       |    3 +-
>  include/linux/ncp_fs.h |    2 +-
>  15 files changed, 140 insertions(+), 94 deletions(-)
> 

