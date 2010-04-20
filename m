Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab0DTQbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 12:31:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:53246 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab0DTQbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 12:31:33 -0400
Date: Tue, 20 Apr 2010 09:23:41 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sysfs: don't use allocated key for lockdep
Message-ID: <20100420162341.GA3232@suse.de>
References: <4BCD246F.4090005@cn.fujitsu.com> <20100420131420.GA27126@suse.de> <alpine.LRH.2.00.1004201805480.28179@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1004201805480.28179@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 06:09:27PM +0200, Jiri Kosina wrote:
> On Tue, 20 Apr 2010, Greg KH wrote:
> 
> > > lockdep_init_map() {
> > > ......
> > > 	/*
> > > 	 * Sanity check, the lock-class key must be persistent:
> > > 	 */
> > > 	if (!static_obj(key)) {
> > > 		printk("BUG: key %p not in .data!\n", key);
> > > 		DEBUG_LOCKS_WARN_ON(1);
> > > 		return;
> > > 	}
> > > 	lock->key = key;
> > > ......
> > > }
> > > 
> > > Could you please fix it.
> > 
> > All in-kernel attributes should now be fixed, so what exactly is the
> > remaining issue?
> 
> Are they?
> 
> How about my fix to drivers/hwmon/asus_atk0110.c for example, I sent last 
> week? http://lkml.org/lkml/2010/4/14/458

Ick, yes, it's still waiting to get sent to Linus, sorry about that,
still catching up on patches :(

thanks,

greg k-h
