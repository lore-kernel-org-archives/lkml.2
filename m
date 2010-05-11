Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab0EKULW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:11:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53517 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709Ab0EKULU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:11:20 -0400
Subject: Re: [BUG] perf_event: when events are grouped, the time enabled / 
 running values are incorrect
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       eranian@google.com
In-Reply-To: <h2i7c86c4471005111255ke689a7acz3a9bbb80480235b0@mail.gmail.com>
References: <4BE4C4BF.6020801@linux.vnet.ibm.com>
	 <1273588935.1810.6.camel@laptop>
	 <h2i7c86c4471005111255ke689a7acz3a9bbb80480235b0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 22:11:16 +0200
Message-ID: <1273608676.1810.61.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 21:55 +0200, stephane eranian wrote:
> Events are also grouped in this example. Both this same issue exists
> also when only
> one event is used. I suspect an update_event_times() or
> update_group_times() is also
> missing on the sampling path in perf_overflow_handler().

Hrmm, you're right, except fixing that is non-trivial.
update_event_times() wants to be called with ctx->lock held and we can't
do that from NMI context.

