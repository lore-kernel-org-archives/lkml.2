Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab1DEHl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 03:41:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:58207 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1DEHl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 03:41:28 -0400
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/mutex.c
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Xiaotian Feng <dfeng@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <alpine.LFD.2.00.1104021653010.22266@localhost6.localdomain6>
References: <4D970CB6.3070604@redhat.com>
	 <alpine.LFD.2.00.1104021653010.22266@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 09:41:16 +0200
Message-ID: <1301989276.2225.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-02 at 21:12 +0200, Thomas Gleixner wrote:
> 
> And it is safe enough for the resume case as well, it simply cannot go
> to sleep because nothing else can hold that mutex in the early resume
> code. We take the mutex during early boot as well, but there the might
> sleep checks are disabled. And we should do the very same thing in the
> early resume code as well. Rafael, PeterZ ??? 

the $subject text sound like it triggered might_sleep(), and that had a
system_state != SYSTEM_RUNNING bail condition, but then, I've no clue
what resume looks like.
