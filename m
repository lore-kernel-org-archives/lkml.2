Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab0DLMyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 08:54:14 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44043 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751907Ab0DLMyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 08:54:13 -0400
Date: Mon, 12 Apr 2010 14:54:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michael Schnell <mschnell@lumino.de>
Cc: David Newall <davidn@davidnewall.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: atomic RAM ?
Message-ID: <20100412125402.GA22773@ucw.cz>
References: <4BBD86A5.5030109@lumino.de> <4BBDA1CB.3070204@davidnewall.com> <4BBDA742.9010507@lumino.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBDA742.9010507@lumino.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> OTOH, to do FUTEX in full (MMU) - Linux, atomic operations are
> definitively necessary, as in Userland you can't disable the interrupt
> without a Kernel call (which to avoid FUTEX is all about.) Currently the

You could create unpriviledged 'disable interrupts for 10
instructions' and 'test if interrupts are still disabled'
instructions, and base your mutex implementation on that.

But you'll have to stop calling it futex at that point...

Or you could just optimize syscalls to be really fast...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
