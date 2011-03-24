Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617Ab1CXHye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:54:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32860 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933351Ab1CXHyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:54:32 -0400
Date: Thu, 24 Mar 2011 08:54:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [origin tree build failure] Re: [PATCH] fs, coda: Fix compile
 warning when CONFIG_SYSCTL=n.
Message-ID: <20110324075413.GA25830@elte.hu>
References: <AANLkTim-U1nyuQ3cVxLHv63LmQUvOJd5GmR5wF90xG==@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim-U1nyuQ3cVxLHv63LmQUvOJd5GmR5wF90xG==@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> When CONFIG_SYSCTL=n, we get the following warning:
> 
> fs/coda/sysctl.c:18: warning: ‘coda_table’ defined but not used
> 
> Following patches fixes the above warning by making sure coda_table
> and it's callee
> function are in the same context. It also cleans up the code by
> removing extra #ifdef.
> 
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
> 
> diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
> index c6405ce..d9cc2b3 100644
> --- a/fs/coda/sysctl.c
> +++ b/fs/coda/sysctl.c

FYI, the v2 of this patch:

  0bc825d240ab: codafs: fix compile warning when CONFIG_SYSCTL=n

broke the upstream build:

  fs/built-in.o: In function `init_coda':
  psdev.c:(.init.text+0x2549): undefined reference to `coda_sysctl_clean'
  fs/built-in.o: In function `exit_coda':
  psdev.c:(.exit.text+0x1bf): undefined reference to `coda_sysctl_clean'
  fs/built-in.o: In function `init_coda_psdev':
 psdev.c:(.text.unlikely+0x21e1): undefined reference to `coda_sysctl_init'

I don't think the -v2 commit was build-tested with !CONFIG_PROC_SYSCTL && 
CONFIG_CODA_FS=y.

	Ingo
