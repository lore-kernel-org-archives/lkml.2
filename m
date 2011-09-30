Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1I3P0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:26:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:53024 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1I3P0I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:26:08 -0400
Subject: Re: [RFC][PATCH 2/5] signal: Add rwlock to protect sighand->action
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anirudh Badam <abadam@cs.princeton.edu>
Date: Fri, 30 Sep 2011 17:25:17 +0200
In-Reply-To: <1317395577-14091-3-git-send-email-matt@console-pimps.org>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
	 <1317395577-14091-3-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317396317.12973.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 16:12 +0100, Matt Fleming wrote:
> 
> As sighand->action is read much more frequently than written a rwlock
> makes the most sense here. 

Ha! you would think so, but then you'd forget that
read_lock()+read_unlock() are atomic ops modifying the lock state as
well. Furthermore rwlocks aren't fair by any means.

Therefore rwlock_t should never be used, use a spinlock_t possibly in
combination with RCU or seqcount etc..
