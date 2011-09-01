Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab1IALnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 07:43:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab1IALna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 07:43:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for Aug 30 (jbd2 + bug.h)
Date: Thu, 1 Sep 2011 13:43:21 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-ext4@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20110830171605.168f29decb0558fa31e59210@canb.auug.org.au> <20110831131429.0513af51.rdunlap@xenotime.net>
In-Reply-To: <20110831131429.0513af51.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109011343.22014.arnd@arndb.de>
X-Provags-ID: V02:K0:2JlWf8DweN36lB71Hu5VQHbeDwu8peNDzStJSXV2JXZ
 /WyGCSx8bwxM/ZFu/R1rq4gz0+VZmh6JZMwArVlKECDsH0q7Ep
 Ek+AGxVQnuvnVpFYDz4oH/uM+Jdbq4WCMwwLJxe+yD5Zzwv4K+
 L/7/E8cuNNUIq/relArxIEZTxnbhHzEgjjlAeGNKIxxrRuKGDF
 RaFWkSQEVrbKPw1Nt/sosI1V1gZYJ5TiK1jOFtlwGj09qEpVPI
 jW3DRwFQeYHKL6+z3cBhTjPL10JxMLMp3mlJMkmeEWoJd+QwYu
 lJaxF/wo858wfBKx89+1oJQD7GvF+SDS1hooyCbkV9+uOxnmka
 1Fh6afqAYQEr1Z93MsLw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 August 2011, Randy Dunlap wrote:
> On Tue, 30 Aug 2011 17:16:05 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> 
> [Sorry about the delay.  My build machine is being slow.
> If this is alread fixed, sorry about the noise.]
> 
> 
> When CONFIG_BUG is not enabled (I see this on x86_64):
> 
> fs/jbd2/transaction.c: In function 'jbd2_journal_dirty_metadata':
> fs/jbd2/transaction.c:1176: error: implicit declaration of function '__WARN'
> 
> 
> asm-generic/bug.h does not provide a version of __WARN() when
> CONFIG_BUG is not enabled...
> 

Hmm, my feeling is that we shouldn't do that either, and that jbd2 should
be changed. If we want a function that does what __WARN() does today, we
should probably make a conscious decision about what we want it to be called
and not have it start with "__".

	Arnd
