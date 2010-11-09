Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab0KITR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:17:59 -0500
Received: from mail.perches.com ([173.55.12.10]:4765 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab0KITR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:17:57 -0500
Subject: Re: [PATCH V2] include/linux/kernel.h: Move logging bits to
 include/linux/logging.h
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=rTw+ByhdGc9prjwvqt_TT=NmOYzEjns1LffLC@mail.gmail.com>
References: <1289281110-8559-1-git-send-email-joe@perches.com>
	 <AANLkTime8YvyHysZF5sX6V2mXWJ0FUtdecpVFgRGqYm6@mail.gmail.com>
	 <1289328235.1823.108.camel@Joe-Laptop>
	 <AANLkTi=rTw+ByhdGc9prjwvqt_TT=NmOYzEjns1LffLC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 11:17:56 -0800
Message-ID: <1289330276.1823.125.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 10:49 -0800, Linus Torvalds wrote:
> On Tue, Nov 9, 2010 at 10:43 AM, Joe Perches <joe@perches.com> wrote:
> > diff from V1 - Don't add pr_<level>_once macros
> >  include/linux/kernel.h  |  244 +--------------------------------------
> >  include/linux/logging.h |  295 +++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 296 insertions(+), 243 deletions(-)
> >  create mode 100644 include/linux/logging.h
> So where do the extra 53 lines come from now?

Differences in logging.h to original kernel.h
were done for cleanliness and checkpatch.

o comment added for purpose of struct va_format
o function no_print() broken into multiple lines
o #ifdef CONFIG_PRINTK vprintk/printk block
  and #else block moved together
o printk_ratelimit and related now have another
  CONFIG_PRINTK and #else block
o pr_debug and pr_debug_ratelimit statement
  expressions are broken into multiple lines

> This still is clearly not just code movement, and it's impossible for
> me to see what actually changed. Something must have.

If you want a nearly identical line count
for logging.h, followed by a cleanup only pass
of logging.h, I'll do that.

Is that what you want?

I didn't recompile and verify this second patch
as all I did was remove the unused for now
pr_<level>_once macros I added.

It takes my slowish setup quite a while to do
full compiles for allyesconfig/allmodconfig/
allnoconfig/defconfig/CONFIG_EMBEDDED/CONFIG_PRINTK=n
variants though so it'd be another day or so before
it'd be verified.

