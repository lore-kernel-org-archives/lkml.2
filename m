Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab0KWUT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 15:19:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750794Ab0KWUTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 15:19:25 -0500
Date: Tue, 23 Nov 2010 12:18:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: wharms@bfs.de, =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, kernel-janitors@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
Message-Id: <20101123121840.e9d17d91.akpm@linux-foundation.org>
In-Reply-To: <203E1F2A-2D04-4B7F-8D1B-9DC24522CB5E@dilger.ca>
References: <1289421483-23907-1-git-send-email-segooon@gmail.com>
	<20101112120834.33062900.akpm@linux-foundation.org>
	<8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca>
	<20101114092533.GB5323@albatros>
	<20101114180643.593d19ac.akpm@linux-foundation.org>
	<1289848341.2607.125.camel@edumazet-laptop>
	<20101123140111.GA3816@hack>
	<4CEBD37E.5060107@bfs.de>
	<203E1F2A-2D04-4B7F-8D1B-9DC24522CB5E@dilger.ca>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 11:02:44 -0700
Andreas Dilger <adilger.kernel@dilger.ca> wrote:

> On 2010-11-23, at 07:45, walter harms wrote:
> > Maybe we can convince the gcc people to make 0 padding default. That will not solve the problems for other compilers but when they claim "works like gcc" we can press then to support this also. I can imagine that this will close some other subtle leaks also.
> 
> It makes the most sense to tackle this at the GCC level, since the added overhead of doing memset(0) on the whole struct may be non-trivial for commonly-used and/or large structures.

(My, what long lines you have!)

We can't reasonably address this with gcc changes.  If gcc starts doing
what we want in the next release, how long will it be until that
release is the *oldest* version of gcc which the kernel may be compiled
with?  Five years?

