Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab2DTHBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 03:01:18 -0400
Received: from teranetworks.de ([188.40.78.98]:36471 "EHLO teranetworks.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab2DTHBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 03:01:16 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2012 03:01:16 EDT
Date: Fri, 20 Apr 2012 08:51:50 +0200
From: Andreas Herz <andi@geekosphere.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de
Subject: msecs_to_jiffies() still returns values greater then MAX_JIFFY_OFFSET
Message-ID: <20120420065150.GG22975@sweethome.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i'm new to the LKML and so i couldn't reply to the old mail from Mar
2011.

On 29 Mar 2011 there was already a disucssion about this issue:

http://lkml.org/lkml/2011/3/29/262

The problem still exists, as /kernel/time.c wasn't patched. I stumbled
upon this "bug" when i modified the ipset sourcecode that uses
msecs_to_jiffies() for timeout calculations.

When i call msecs_to_jiffies(2147483000) the return value is 2147483000
on my x86 32-Bit System with 1000Hz. When i call the function with
msecs_to_jiffies(2147484000) the return value is MAX_JIFFY_OFFSET what's
1073741822 on my system. That isn't the behaviour i expect from this
comment in time.c:

 * - 'too large' values [that would result in larger than
 *   MAX_JIFFY_OFFSET values] mean 'infinite timeout' too.

So you can pass values greater then MAX_JIFFY_OFFSET up to INT_MAX in
this example although the limit should be at INT_MAX/2 for
MAX_JIFFY_OFFSET. 

I'm not sure if the solution is to increase MAX_JIFFY_OFFSET or to catch
values between this gap. I also don't understand why the function
returns a unsigned long but is limited to integer. It could be nice to
increase the values that can be handled with this function.

Greetings

-- 
Andreas Herz
