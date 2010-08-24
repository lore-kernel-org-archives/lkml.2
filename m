Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0HXKgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:36:13 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:34213 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab0HXKgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 06:36:12 -0400
Subject: Re: workqueue destruction BUG_ON
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C739DC6.1040309@kernel.org>
References: <1282640156.3695.5.camel@jlt3.sipsolutions.net>
	 <4C739DC6.1040309@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 12:37:48 +0200
Message-ID: <1282646268.3695.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > In our testing with iwlwifi, we keep running into this BUG_ON:
> > 
> > 	BUG_ON(cwq->nr_active);
> > 
> > in destroy_workqueue(). This is quite unhelpful, and since the code
> > flushes the workqueue I really don't see how this could be happening,
> > unless maybe there's cross-talk between this and other workqueues?
> 
> Flushing the workqueue doesn't guarantee that the workqueue stays
> empty.

True.

> It just flushes the currently pending works.  If there are
> requeueing works or something else is queueing new works, workqueue
> won't be empty.  The check is new.  Previously, workqueue code didn't
> check whether the workqueue is actually empty.  Now that the worklist
> is shared, we need such check in place.  There was also a similar
> report on ath9k.  I think it's most likely that something is queueing
> works on a dying wokrqueue in the wireless common code.

I think in my iwlwifi case it's actually destroying the iwlwifi
workqueue (not sure why it even exists though).

>   I'll prep a
> debug patch to print out some details.

That'd be helpful, thanks!

johannes

