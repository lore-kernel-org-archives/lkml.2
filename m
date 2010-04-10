Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab0DJRAF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 13:00:05 -0400
Received: from waste.org ([173.11.57.241]:49401 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab0DJRAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 13:00:02 -0400
Subject: Re: [PATCH] random: Forbid llseek on random chardev
From: Matt Mackall <mpm@selenic.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20100410163529.GI5204@nowhere>
References: <1270909064-7845-1-git-send-regression-fweisbec@gmail.com>
	 <1270916750.28124.23.camel@calx>  <20100410163529.GI5204@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Apr 2010 11:59:57 -0500
Message-ID: <1270918797.28124.27.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-10 at 18:35 +0200, Frederic Weisbecker wrote:
> On Sat, Apr 10, 2010 at 11:25:50AM -0500, Matt Mackall wrote:
> > On Sat, 2010-04-10 at 16:17 +0200, Frederic Weisbecker wrote:
> > > From: Arnd Bergmann <arnd@arndb.de>
> > > 
> > > Seeking on /dev/random and /dev/urandom is pointless.
> > 
> > It is indeed pointless, though that doesn't mean no one does it. 
> > Forbidding a no-op seems a rather unfriendly way to fix this.
> 
> 
> I worried about that too. If you think that could break some user
> space apps, we can make it a generic_file_llseek.
> 
>  
> > > Using generic_file_llseek means we no longer need to
> > > take the BKL if anyone tries to seek on these.
> > 
> > Comment doesn't match the patch?
> 
> 
> Oops. I guess the patch has been updated, but not the changelog.
> 
> Some background: we are trying to remove the uses of default_llseek
> that use the bkl. We started with turning llseek stubs to
> generic_file_llseek (or non seekable open in some cases), but we are
> hesitating now and think about actually turn all the stubs that
> might need the bkl into default_llseek, and fallback to
> generic_file_llseek for all other stubs.
> 
> Depending on what we do I'll resend you an updated version
> of this patch with generic_file_llseek, or I will let the stub
> as is.

Sounds good.

-- 
http://selenic.com : development and support for Mercurial and Linux


