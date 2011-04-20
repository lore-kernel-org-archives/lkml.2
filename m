Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1DTCqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 22:46:12 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49173 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1DTCqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 22:46:11 -0400
Subject: Re: [PATCH 1/2] break out page allocation warning code
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20110420112006.461A.A69D9226@jp.fujitsu.com>
References: <1303263673.5076.612.camel@nimitz>
	 <20110420105059.460C.A69D9226@jp.fujitsu.com>
	 <20110420112006.461A.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 19 Apr 2011 19:46:02 -0700
Message-ID: <1303267562.5076.1004.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 11:19 +0900, KOSAKI Motohiro wrote:
> > +     memcpy(tmp_comm, tsk->comm_buf, TASK_COMM_LEN);
> > +     tsk->comm = tmp;
> >       /*
> > -      * Threads may access current->comm without holding
> > -      * the task lock, so write the string carefully.
> > -      * Readers without a lock may see incomplete new
> > -      * names but are safe from non-terminating string reads.
> > +      * Make sure no one is still looking at tsk->comm_buf
> >        */
> > -     memset(tsk->comm, 0, TASK_COMM_LEN);
> > -     wmb();
> > -     strlcpy(tsk->comm, buf, sizeof(tsk->comm));
> > +     synchronize_rcu();
> 
> The doc says,
> 
> /**
>  * synchronize_rcu - wait until a grace period has elapsed.

Yeah, yeah... see "completely untested". :)

I'll see if dropping the locks or something else equally hackish can
help.  

-- Dave

