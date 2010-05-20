Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab0ETQXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:23:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652Ab0ETQXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:23:33 -0400
Date: Thu, 20 May 2010 09:20:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>, Don Prince <dhprince-devel@yahoo.co.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] HID
In-Reply-To: <alpine.LNX.2.00.1005191430370.28092@pobox.suse.cz>
Message-ID: <alpine.LFD.2.00.1005200912540.23538@i5.linux-foundation.org>
References: <alpine.LNX.2.00.1005191430370.28092@pobox.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 May 2010, Jiri Kosina wrote:
> 
> please pull from 'for-linus' branch from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus
> 
> to receive HID subsystem patches queued for 2.6.35 merge window.

This is just unbelievable SH*T:

	config HID_ZYDACRON
		tristate "Zydacron remote control support" if EMBEDDED
		depends on USB_HID
		default !EMBEDDED
		---help---
		Support for Zydacron remote control.

First it says "only ask if EMBEDDED", and then it says "default to Y if 
not embedded".

Why? Why the hell did somebody decide that everybody and their pet dog 
should get that totally uninteresting driver, whether they want it or not?

I realize that every single developer thinks that their driver is the most 
important thing in the universe, but come on! This kind of thing is 
totally inappropriate, and to make matters worse, it looks like there are 
a few commits that won't even compile because the whole file wasn't even 
added until later.

And this piece of shit was made _mandatory_?

Get a grip, people. I'm not pulling idiotic crap like this. Some quality 
control before you ask me to pull, for chissake!

		Linus
