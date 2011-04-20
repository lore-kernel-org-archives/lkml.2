Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1DTAjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 20:39:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37650 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1DTAjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 20:39:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/2] break out page allocation warning code
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1104191419470.510@chino.kir.corp.google.com>
References: <20110419094422.9375.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104191419470.510@chino.kir.corp.google.com>
Message-Id: <20110420093900.45F6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 20 Apr 2011 09:39:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 19 Apr 2011, KOSAKI Motohiro wrote:
> 
> > The rule is,
> > 
> > 1) writing comm
> > 	need task_lock
> > 2) read _another_ thread's comm
> > 	need task_lock
> > 3) read own comm
> > 	no need task_lock
> > 
> 
> That was true a while ago, but you now need to protect every thread's 
> ->comm with get_task_comm() or ensuring task_lock() is held to protect 
> against /proc/pid/comm which can change other thread's ->comm.  That was 
> different before when prctl(PR_SET_NAME) would only operate on current, so 
> no lock was needed when reading current->comm.

Right. /proc/pid/comm is evil. We have to fix it. otherwise we need change
all of current->comm user. It's very lots!



