Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab1EWUTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:19:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:53502 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab1EWUTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:19:02 -0400
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, fbuihuu@gmail.com, mingo@elte.hu,
        paulus@samba.org, acme@redhat.com
In-Reply-To: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 22:22:21 +0200
Message-ID: <1306182141.2497.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 16:04 -0400, Vince Weaver wrote:
> Hello
> 
> the changeset 2e939d1d   perf: Limit event refresh to sampling event
> 
> changes the behavior of
>   ioctl( , PERF_EVENT_IOC_REFRESH, )
> 
> before the changeset, you could have a counter group where only one of the 
> subevents was sampling.  PERF_EVENT_IOC_REFRESH would correctly enable 
> sampling for only that subevent.

But how? it adds to the event_limit of the event you call the ioctl()
on, not on any of the group siblings.

> With the changeset applied, this fails with EINVALID.  Now you can only 
> sample in a group leader.

I'm not quite seeing how group-leaders are relevant here, you can only
call this ioctl() on sampling events, regardless of if they're they
group leader or a sibling.

> Was this an intended change?  It breaks various of our PAPI regression 
> tests that worked fine before the change was committed.

I'm not quite seeing what's wrong yet, the change seemed simple enough
in that calling that ioctl() on an event that wasn't capable of
generating samples doesn't make sense, since it will increase the event
limit for the event you call it on.



