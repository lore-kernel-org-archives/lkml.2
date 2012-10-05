Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab2JETyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:54:25 -0400
Received: from smtp.getmail.no ([84.208.15.66]:57645 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab2JETyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:54:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
In-reply-to: <1349146202.7086.23.camel@marge.simpson.net>
References: <op.wlf5j0i76426ze@localhost.localdomain>
 <1349064397.6957.26.camel@marge.simpson.net>
 <op.wlh4u2xj6426ze@millennium.getinternet.no>
 <1349146202.7086.23.camel@marge.simpson.net>
Subject: Re: The 10ms averager in fair.c
To: linux-kernel@vger.kernel.org
Date: Fri, 05 Oct 2012 21:54:22 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wlp1kwg76426ze@localhost.localdomain>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok I have gained a bit more information on this now. Apparently, the  
filter is there, for HPC loads to exclude scheduler activity itself from  
the scheduler?

Filtering all the processes for this, seems completely unessecary though.  
Depending on what resolution these filters run at, you have 50 filters  
running at resolution X, only to do that, with 50 processes. Why not just  
replace that with a simple, on off, say cpu usage = 0 for the first 1 ms.  
Scheduler activity probably doesn`t last longer than that, atleast with  
preempt on. And with a filter you will have 10ms activity indication after  
the last input. That should just be truncated, and after 1ms things should  
just work on peak values. (not average).

 From thinking about how this filter would improve anything, that seems  
like the better way to do anything like that.

Peace Be With You.
