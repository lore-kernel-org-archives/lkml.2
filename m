Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab0KJJdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 04:33:53 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54921 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290Ab0KJJdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 04:33:50 -0500
X-Sasl-enc: sA54FYu30Hjr5mmwEh4VWOAuNuBM6CbKFxLKft4A2gv7 1289381629
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/5] ecryptfs fixes
Date: Wed, 10 Nov 2010 10:31:33 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-61.fc13.x86_64; KDE/4.5.2; x86_64; ; )
Cc: kirkland@canonical.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <201011031111.06669.roberto.sassu@polito.it> <20101109220144.GA3599@boyd.l.tihix.com>
In-Reply-To: <20101109220144.GA3599@boyd.l.tihix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011101031.34153.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tyler

thanks for accepting my patches. 
There is another O_RDONLY test in the function ecryptfs_privileged_open(), in the file fs/ecryptfs/kthread.c,
that is not actually fixed, because i need some explanations on the code.
In this function the dentry_open() is called first time with flags (O_LARGEFILE | O_RDWR) or
(O_LARGEFILE | O_RDONLY) depending on the options passed during the mount of the lower
filesystem.
If the dentry_open() fails, a lower_file pointer can be obtained from the function ecryptfs_threadfn()
executed by the kernel kthread service. However, this option is available only if the lower filesystem
is mounted in read-write mode.
Can you explain me this?
Thanks.

Roberto


On Tuesday, November 09, 2010 11:01:44 pm Tyler Hicks wrote:
> On Wed Nov 03, 2010 at 11:11:06AM +0100, Roberto Sassu <roberto.sassu@polito.it> wrote:
> > This patch set applies to the latest kernel 2.6.37-rc1.
> > 
> > 
> > Roberto Sassu (5):
> >   ecryptfs: moved ECRYPTFS_SUPER_MAGIC definition to linux/magic.h
> >   ecryptfs: missing initialization of the superblock 'magic' field
> >   ecryptfs: test lower_file pointer when lower_file_mutex is locked
> >   ecryptfs: fixed testing of file descriptor flags
> >   ecryptfs: open lower files with kthread credentials
> 
> Hey Roberto - I pushed these patches to
> git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git#next
> 
> Thanks,
> Tyler
> 
> > 
> >  fs/ecryptfs/ecryptfs_kernel.h |    4 +---
> >  fs/ecryptfs/file.c            |   20 +++++++++-----------
> >  fs/ecryptfs/inode.c           |   32 ++++++++++++++------------------
> >  fs/ecryptfs/kthread.c         |   17 +++++++++++++----
> >  fs/ecryptfs/main.c            |    5 +++--
> >  include/linux/magic.h         |    1 +
> >  6 files changed, 41 insertions(+), 38 deletions(-)
> > 
> 
> 
> 
