Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab2G1IMk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 04:12:40 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55142 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398Ab2G1IMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 04:12:36 -0400
Message-ID: <1343463151.3328.4.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] debug: Do not permit CONFIG_DEBUG_STACK_USAGE=y on IA64
 or PARISC
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-ia64@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
Date: Sat, 28 Jul 2012 09:12:31 +0100
In-Reply-To: <4a613b26cc402fb3ed8130cd07a37e76f4c133ef.1342634029.git.tony.luck@intel.com>
References: <4a613b26cc402fb3ed8130cd07a37e76f4c133ef.1342634029.git.tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 10:35 -0700, Tony Luck wrote:
> The stack_not_used() function in <linux/sched.h> assumes that stacks
> grow downwards. This is not true on IA64 or PARISC, so this function
> would walk off in the wrong direction and into the weeds.

OK, so looking at all of this, that statement's not quite true ... at
least for parisc, we begin the stack where end_of_stack() says the end
should be and so the walker will likely find the next word after the
canary skip occupied and terminate there, so we think the stack is
larger than it really is.  It gets the wrong value, but it will never
even walk out of the stack area.

> Found on IA64 because of a compilation failure with recursive dependencies
> on IA64_TASKSIZE and IA64_THREAD_INFO_SIZE.
> 
> Fixing the code is possible, but should be combined with other
> infrastructure additions to set up the "canary" at the end of the stack.

I agree with this.  Most of it looks easily fixable, but how would I
enable the fix for ia64?  For PA it's simple: I'll just use
CONFIG_STACK_GROWSUP, but that won't work for you.

James


