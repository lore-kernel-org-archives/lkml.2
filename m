Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab0EKUXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:23:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39088 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab0EKUXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:23:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=V+vXY9RFbOhh5XDV8Y1KMIfZZSIeBgYiGiHJ9/Gi/dvAH2VfYcMOOHVNAthtU5Mhk
	KNbmb/hxcqzS3JjGPL7ag==
MIME-Version: 1.0
In-Reply-To: <1273608676.1810.61.camel@laptop>
References: <4BE4C4BF.6020801@linux.vnet.ibm.com>
	 <1273588935.1810.6.camel@laptop>
	 <h2i7c86c4471005111255ke689a7acz3a9bbb80480235b0@mail.gmail.com>
	 <1273608676.1810.61.camel@laptop>
Date: Tue, 11 May 2010 22:23:38 +0200
Message-ID: <AANLkTilVGy3nLymHUj-blglsL3y5ApyhUWrunxJYeQPb@mail.gmail.com>
Subject: Re: [BUG] perf_event: when events are grouped, the time enabled / 
	running values are incorrect
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@gmail.com, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 10:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-05-11 at 21:55 +0200, stephane eranian wrote:
>> Events are also grouped in this example. Both this same issue exists
>> also when only
>> one event is used. I suspect an update_event_times() or
>> update_group_times() is also
>> missing on the sampling path in perf_overflow_handler().
>
> Hrmm, you're right, except fixing that is non-trivial.
> update_event_times() wants to be called with ctx->lock held and we can't
> do that from NMI context.
>
Why do you need the lock when the event is running on a CPU in NMI context?
What action issued remotely could modify the data used by this function without
the need for IPI?
