Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0GKKbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 06:31:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52904 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab0GKKbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 06:31:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] Remove BKL from fs/locks.c
Date: Sun, 11 Jul 2010 12:31:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Matthew Wilcox <willy@linux.intel.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
       linux-fsdevel@vger.kernel.org
References: <1278798701-11171-1-git-send-email-arnd@arndb.de> <1278798701-11171-3-git-send-email-arnd@arndb.de> <20100710220110.GA13380@lst.de>
In-Reply-To: <20100710220110.GA13380@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007111231.18926.arnd@arndb.de>
X-Provags-ID: V02:K0:a7iXTAtfCCJtOBOH6oOml0FdD6OPFRShQLoonwvgBT7
 b/Bkb5jlzszj+d6mikvEnz5L7Jses+wLfgM/z5m6p7oNiT1Hsw
 1ddWVdsksvDojJsr8fMvnO5uLMCSyJYP1+HUmHOR/yHtCiItIJ
 imd/KyOpBgwBj0Hzh1StmEM8r2y43x8sNQrLTQiKtCE0fIor9Z
 uN7+rZk8aEQl4QWkRtasw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 July 2010 00:01:10 Christoph Hellwig wrote:
> On Sat, Jul 10, 2010 at 11:51:40PM +0200, Arnd Bergmann wrote:
> > From: Matthew Wilcox <willy@linux.intel.com>
> > 
> > I've taken a patch originally written by Matthew Wilcox and
> > ported it to the current version. Unfortunately, the change
> > conflicts with the use of lockd, which still heavily uses
> > the big kernel lock.
> > 
> > As a workaround, I've made the behaviour configurable,
> > it either uses the BKL when it's enabled or a spinlock
> > when the BKL (and consequently nfs and lockd) are
> > disabled.
> 
> Defintively not something we want in mainline.  But keep poking
> the nfs guys to sort the lockd mess out for real.

Yes, that was the idea. This is the last patch I need to run
all of my machines without the BKL, so I spent a few hours
looking at how to fix lockd. When I couldn't figure it out,
I decided to do an evil hack that happens to work, in order
to build pressure.

	Arnd
