Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab2E3SiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:38:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39965 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751652Ab2E3SiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:38:12 -0400
Date: Wed, 30 May 2012 14:38:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Use of high-res timers
Message-ID: <Pine.LNX.4.44L0.1205301419090.1543-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, Ingo, or anyone else:

My driver needs to time a bunch of events, with roughly millisecond
precision.  Up to now it has used old-fashioned timer_lists and the
jiffies counter, but I'm switching over to high-resolution timers and
ktime_get.

This leads to a few questions (these issues don't seem to be addressed 
anywhere in Documentation/timers):

	Should I be concerned about efficiency?  I may well end up
	calling ktime_get several times per millisecond; is it fast
	enough for this to be okay?

	I need timed intervals with reliable lower bounds.  Let's say
	I call ktime_get twice, maybe once in an interrupt handler and
	once in an hrtimer callback (not necessarily on the same CPU).
	Some action has to be taken no earlier than 1 ms after the 
	first call.  If the second call returns a value that is at 
	least 1 ms larger than the first call, is that enough of a 
	guarantee?  If not, how much larger does it have to be?

	Which has more overhead: adding and cancelling an hrtimer
	several times, or simply letting it expire and returning
	immediately from the callback?  (I wouldn't be surprised if
	there was no good answer.)

Thanks,

Alan Stern

