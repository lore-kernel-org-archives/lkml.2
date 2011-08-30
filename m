Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1H3JOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:14:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:47526 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1H3JOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:14:43 -0400
Subject: Re: Linux 3.1-rc4
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 30 Aug 2011 11:14:30 +0200
In-Reply-To: <20110830070715.GA15134@liondog.tnic>
References: <CA+55aFwwtfLpmNS+Wm4DXgJsipPS8siF6Dur4rMDum7Zs=KqKw@mail.gmail.com>
	 <20110830070715.GA15134@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314695670.2054.6.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 09:07 +0200, Borislav Petkov wrote:
> On Sun, Aug 28, 2011 at 09:52:43PM -0700, Linus Torvalds wrote:
> > We're back on track on weekly -rc releases.
> 
> Peter,
> 
> I get the following lockdep splat on -rc4, it looks like load balancing
> something.
> 
> [ 5183.478132] ------------[ cut here ]------------
> [ 5183.478155] WARNING: at kernel/lockdep.c:690 __lock_acquire+0x189/0x916()

that's:

look_up_lock_class():
                        WARN_ON_ONCE(class->name != lock->name);

That's something that really shouldn't happen and my first guess is that
you're suffering some memory corruption.


