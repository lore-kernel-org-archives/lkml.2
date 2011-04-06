Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1DFIHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 04:07:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38787 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab1DFIHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 04:07:52 -0400
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/mutex.c
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Xiaotian Feng <dfeng@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <201104060643.38301.rjw@sisk.pl>
References: <4D970CB6.3070604@redhat.com>
	 <alpine.LFD.2.00.1104021653010.22266@localhost6.localdomain6>
	 <1301989276.2225.1.camel@twins>  <201104060643.38301.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Apr 2011 10:07:33 +0200
Message-ID: <1302077253.2225.1360.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 06:43 +0200, Rafael J. Wysocki wrote:
> > the $subject text sound like it triggered might_sleep(), and that had a
> > system_state != SYSTEM_RUNNING bail condition, but then, I've no clue
> > what resume looks like.
> 
> Early resume looks pretty much like the system startup, e.g. everything
> called from syscore_ops should not be sleepable (although mutexes shouldn't
> trigger, because that code is effectively single-threaded, unless somebody
> holds the mutex in question when that code is being executed, but that would
> deadlock anyway). 

Right, so system_state != SYSTEM_RUNNING should be true for resume?
