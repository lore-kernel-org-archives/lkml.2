Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab2JGRJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 13:09:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54660 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab2JGRJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 13:09:01 -0400
Date: Sun, 7 Oct 2012 18:08:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dl8bcu@dl8bcu.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [regression] boot failure on alpha, bisected
Message-ID: <20121007170850.GJ2616@ZenIV.linux.org.uk>
References: <20121006204736.GA1830@ds20.borg.net>
 <20121007165534.GA8024@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121007165534.GA8024@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 06:55:34PM +0200, Oleg Nesterov wrote:

> Hmm. I know nothing about arch/alpha and I can't understand its entry.S.
> But _it seems_ to me that do_notify_resume() is called with irqs disabled.
> If this is true, then imho arch/alpha should be fixed.
> 
> Before this commit task_work_run() enabled irqs, but this was the "side
> effect" of spin_lock_irq/spin_unlock_irq, we should not rely on this.

Um...  There's a bunch of architectures that are in the same situation.
grep for do_notify_resume() and you'll see...

It needs to be dealt with sanely, and actually have patches for alpha
going in that direction, but breaking a bunch of architectures is not a good
thing, obviously.  So you've bought yourself a major PITA for coming
weeks...
