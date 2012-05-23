Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716Ab2EWRsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:48:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37805 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760671Ab2EWRsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:48:51 -0400
Date: Wed, 23 May 2012 19:48:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/urgent fixes for v3.5
Message-ID: <20120523174844.GA3373@gmail.com>
References: <20120523113432.GA12142@gmail.com>
 <CA+55aFzCDKK56CRXWXrPPtok84KJY4BbORcT3GfEH8xmOfgP6g@mail.gmail.com>
 <4FBD1AC8.7020602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBD1AC8.7020602@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 05/23/2012 10:07 AM, Linus Torvalds wrote:
> > On Wed, May 23, 2012 at 4:34 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >>
> >> Sasha Levin (1):
> >>      x86, printk: Add missing KERN_CONT to NMI selftest
> > 
> > Why? This seems to be garbage.
> > 
> 
> This was added to the urgent branch earlier (but it wasn't 
> worth pushing late in rc) but apparently a more underlying bug 
> was fixed in the meantime.
> 
> It didn't seem worth removing since the KERN_CONT should 
> really be there anyway.

I'm not sure it should be there: if there's no KERN_ prefix in a 
printk, and the previous printk from this context did not end 
with \n, then the KERN_CONT should be implicit.

KERN_CONT is really special, for rare cases where you want to 
explicitly avoid the <> priority field or to construct it.

Or at least that's how I understand this area, it might have 
been updated meanwhile - Linus?

Also, we can rebase the whole branch and get rid of this one and 
of the merge commit it has.

Thanks,

	Ingo
