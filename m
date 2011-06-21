Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab1FULgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 07:36:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab1FULgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 07:36:39 -0400
Date: Tue, 21 Jun 2011 13:36:29 +0200
From: Frantisek Hrbata <fhrbata@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        CAI Qian <caiqian@redhat.com>, lwoodman@redhat.com
Subject: Re: [PATCH] oom: add uid to "Killed process" message
Message-ID: <20110621113629.GA2758@dhcp-26-164.brq.redhat.com>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <1308567876-23581-1-git-send-email-fhrbata@redhat.com>
 <alpine.DEB.2.00.1106201409090.2639@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1106201409090.2639@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 02:09:19PM -0700, David Rientjes wrote:
> On Mon, 20 Jun 2011, Frantisek Hrbata wrote:
> 
> > Add user id to the oom killer's "Killed process" message, so the user of the
> > killed process can be identified.
> > 
> 
> Notified in what way?  Unless you are using the memory controller, there's 
> no userspace notification that an oom event has happened so nothing would 
> know to scrape the kernel log for this information.

Agreed, but this is not primary about notification, but about the availability of
the information at all, even if it's just in the kernel log and there is no
realtime notification about it. If I'm not missing anything, now you are not
notified if some process is killed neither(unless as you mentioned, you use
eventfd for memory.oom_control). But you can always inspect the kernel log
afterwards when you find out that some process is not running and you want to
know what happened. And here you have the information that the process was
killed by the oom killer.

I guess the uid of the killed process can be identified from the dump_tasks
output, where it is presented along with other info. I think it is handy
to have the uid info directly in the "Killed process" message. 

This is used/requested by one of our customers and since I think it's a good
idea to have the uid info presented, I posted the patch here to see what do you
think about it.

Many thanks

> 
> We've had a long-time desire for an oom notifier, not only at the time of 
> oom but when approaching it with configurable thresholds, that would 
> wakeup a userspace daemon that might be polling on notifier.  That seems 
> more useful for realtime notification of an oom event rather than relying 
> on the kernel log?


-- 
Frantisek Hrbata
