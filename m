Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab2KXAKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:10:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932296Ab2KXAKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:10:53 -0500
Date: Fri, 23 Nov 2012 19:10:40 -0500
From: Dave Jones <davej@redhat.com>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Tell the world we gave up on pushing CC_OPTIMIZE_FOR_SIZE
Message-ID: <20121124001040.GA29164@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kirill Smelkov <kirr@mns.spb.ru>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1351856461-3662-1-git-send-email-kirr@mns.spb.ru>
 <20121122081041.GA380@tugrik.mns.mnsspb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121122081041.GA380@tugrik.mns.mnsspb.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 12:10:41PM +0400, Kirill Smelkov wrote:
 
 > Linus, maybe you missed this. What is the reason telling people
 > CC_OPTIMIZE_FOR_SIZE should be Y if we actually do otherwise?
 > 
 > 
 > commit 281dc5c5ec0fb299514567cbc358562649c1af95
 > Author: Linus Torvalds <torvalds@linux-foundation.org>
 > Date:   Sun May 22 14:30:36 2011 -0700
 > 
 >     Give up on pushing CC_OPTIMIZE_FOR_SIZE
 >     
 >     I still happen to believe that I$ miss costs are a major thing, but
 >     sadly, -Os doesn't seem to be the solution.  With or without it, gcc
 >     will miss some obvious code size improvements, and with it enabled gcc
 >     will sometimes make choices that aren't good even with high I$ miss
 >     ratios.
 >     
 >     For example, with -Os, gcc on x86 will turn a 20-byte constant memcpy
 >     into a "rep movsl".  While I sincerely hope that x86 CPU's will some day
 >     do a good job at that, they certainly don't do it yet, and the cost is
 >     higher than a L1 I$ miss would be.
 >     
 >     Some day I hope we can re-enable this.
 >     
 >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
 > 
 > diff --git a/init/Kconfig b/init/Kconfig
 > index 4986ecc..ffcdad7 100644
 > --- a/init/Kconfig
 > +++ b/init/Kconfig
 > @@ -908,7 +908,6 @@ endif
 >  
 >  config CC_OPTIMIZE_FOR_SIZE
 >         bool "Optimize for size"
 > -       default y
 >         help
 >           Enabling this option will pass "-Os" instead of "-O2" to gcc
 >           resulting in a smaller kernel.
 
FWIW, we gave up using this in Fedora quite a few releases back because we
kept finding workloads that it truly sucked on.
For code that is quite bloaty and not particularly performance critical,
maybe we could move -Os to individual directories.

	Dave
