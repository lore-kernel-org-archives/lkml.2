Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab2GEVjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 17:39:32 -0400
Received: from waste.org ([173.11.57.241]:35228 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab2GEVja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 17:39:30 -0400
Message-ID: <1341524367.4020.1324.camel@calx>
Subject: Re: [PATCH 01/10] random: make 'add_interrupt_randomness()' do
 something sane
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org
Date: Thu, 05 Jul 2012 16:39:27 -0500
In-Reply-To: <CA+55aFyMYVLCW0OYTVttkjjOwyu9VgDM9haNC=BeoRCEiWWNPQ@mail.gmail.com>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
	 <1341511933-11169-2-git-send-email-tytso@mit.edu>
	 <1341514078.4020.1213.camel@calx>
	 <CA+55aFyMYVLCW0OYTVttkjjOwyu9VgDM9haNC=BeoRCEiWWNPQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 11:52 -0700, Linus Torvalds wrote:
> On Thu, Jul 5, 2012 at 11:47 AM, Matt Mackall <mpm@selenic.com> wrote:
> >
> > I think you should demand a minimum number of events > HZ to actually
> > credit any valid entropy.
> 
> There already is. It's 1.

> If we don't get a single non-timer interrupt, this code will never be called.

>From my read, this code path gets called on timer interrupts too. Thus
the number of events per HZ will be HZ at a minimum on systems that
haven't gone tickless. If such systems a) don't have a higher-res time
source and b) are halted or equivalent, such samples will be completely
deterministic. So the threshold for crediting entropy should be HZ + 1.

But perhaps I've missed something.

(As I expressed in my last message, this is strictly a correctness issue
and not a practical one. I've long held that the entropy counting model
is bogus and should be abandoned.)

-- 
Mathematics is the supreme nostalgia of our time.


