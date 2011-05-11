Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab1EKBUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 21:20:53 -0400
Received: from mail.perches.com ([173.55.12.10]:1480 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab1EKBUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 21:20:52 -0400
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
From: Joe Perches <joe@perches.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <1305076246.2939.67.camel@work-vm>
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org>
	 <1305073386-4810-3-git-send-email-john.stultz@linaro.org>
	 <1305075090.19586.189.camel@Joe-Laptop>  <1305076246.2939.67.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 18:20:50 -0700
Message-ID: <1305076850.19586.196.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 18:10 -0700, John Stultz wrote:
> On Tue, 2011-05-10 at 17:51 -0700, Joe Perches wrote:
> > On Tue, 2011-05-10 at 17:23 -0700, John Stultz wrote:
> > > Acessing task->comm requires proper locking. However in the past
> > > access to current->comm could be done without locking. This
> > > is no longer the case, so all comm access needs to be done
> > > while holding the comm_lock.
> > Could misuse of %ptc (not using current) cause system lockup?
> It very well could. Although I don't see other %p options tring to
> handle invalid pointers. Any suggestions on how to best handle this?

The only one I know of is ipv6 which copies a 16 byte buffer
in case the pointed to value is unaligned.  I suppose %pI6c
could be a problem or maybe %pS too, but it hasn't been in
practice.  The use of %ptc somehow seemed more error prone.

> Most users are current, so forcing the more rare
> non-current users to copy it to a buffer first and use the normal %s
> would not be of much impact.
> 
> Although I'm not sure if there's precedent for a %p value that didn't
> take a argument. Thoughts on that? Anyone else have an opinion here?

The uses of %ptc must add an argument or else gcc will complain.
I suggest you just ignore the argument value and use current.


