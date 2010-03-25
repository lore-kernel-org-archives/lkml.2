Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0CYWMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:12:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51647 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab0CYWLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:11:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 09/15] PM / Hibernate: user, implement user_ops writer
Date: Thu, 25 Mar 2010 23:14:33 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <20100324204259.GA6423@elf.ucw.cz> <4BAA86E8.5090108@gmail.com>
In-Reply-To: <4BAA86E8.5090108@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003252314.33256.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 March 2010, Jiri Slaby wrote:
> On 03/24/2010 09:42 PM, Pavel Machek wrote:
> >> +	if (test_bit(TODO_CLOSED, to_do_flags))
> >> +		return -EIO;
> >> +
> >> +	to_do_buf = buf;
> >> +	wmb();
> >> +	set_bit(TODO_WORK, to_do_flags);
> >> +	wake_up_interruptible(&to_do_wait);
> > 
> > Uhuh, open-coded barriers... these need to be commented, and I guess
> > you just should not play this kind of trickery.
> 
> It's just to ensure the to_do_buf store is not reordered with the
> set_bit. I wanted to avoid locks as too heavy tools here.

No, please use them, at least in a prototype version.

We can always optimize things out later, but doing optimizations upfront
doesn't really work well from my experience.

So, if you'd use a lock somewhere, please use it, or maybe use a completion if
that fits the design better.  In the majority of cases it's not as heavy wieght
as it seems at first sight.

Rafael
