Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab0CYVhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 17:37:05 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:58422 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750967Ab0CYVhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 17:37:01 -0400
Date: Thu, 25 Mar 2010 22:36:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC 09/15] PM / Hibernate: user, implement user_ops writer
Message-ID: <20100325213642.GF22902@elf.ucw.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
 <1269361063-3341-9-git-send-email-jslaby@suse.cz>
 <20100324204259.GA6423@elf.ucw.cz>
 <4BAA86E8.5090108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA86E8.5090108@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-03-24 22:40:56, Jiri Slaby wrote:
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

Locks are the only sane choice here. Open coding them is not an option.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
