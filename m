Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab1E3BRi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 21:17:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56613 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab1E3BRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 21:17:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE2F028.6020608@jp.fujitsu.com>
Date: Mon, 30 May 2011 10:17:28 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: rientjes@google.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 4/5] oom: don't kill random process
References: <4DD61F80.1020505@jp.fujitsu.com> <4DD6207E.1070300@jp.fujitsu.com> <alpine.DEB.2.00.1105231529340.17840@chino.kir.corp.google.com> <4DDB0B45.2080507@jp.fujitsu.com> <alpine.DEB.2.00.1105231838420.17729@chino.kir.corp.google.com> <4DDB1028.7000600@jp.fujitsu.com> <alpine.DEB.2.00.1105231856210.18353@chino.kir.corp.google.com> <4DDB11F4.2070903@jp.fujitsu.com> <alpine.DEB.2.00.1105251645270.29729@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1105251645270.29729@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm afraid that a second time through the tasklist in select_bad_process() 
> is simply a non-starter for _any_ case; it significantly increases the 
> amount of time that tasklist_lock is held and causes problems elsewhere on 
> large systems -- such as some of ours -- since irqs are disabled while 
> waiting for the writeside of the lock.  I think it would be better to use 
> a proportional privilege for root processes based on the amount of memory 
> they are using (discounting 1% of memory per 10% of memory used, as 
> proposed earlier, seems sane) so we can always protect root when necessary 
> and never iterate through the list again.
> 
> Please look into the earlier review comments on the other patches, refresh 
> the series, and post it again.  Thanks!

Never mind.

You never see to increase tasklist_lock. You never seen all processes
have root privilege case.

