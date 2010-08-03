Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab0HCBz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 21:55:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:33415 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab0HCBz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 21:55:56 -0400
Subject: Re: Possible Oprofile crash/race when stopping
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Carl E. Love" <cel@us.ibm.com>,
        Michael Ellerman <michaele@au1.ibm.com>
In-Reply-To: <20100728122111.GO26154@erda.amd.com>
References: <1279775680.1970.13.camel@pasglop>
	 <20100728122111.GO26154@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 11:39:33 +1000
Message-ID: <1280799573.1902.81.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Benjamin,
> 
> thanks for reporting this. I was trying to reproduce this with various
> loads and scenarios, but without success so far. Can you give me a
> hint of the load you have (number of processes running, cpu load, do
> you switch off oprofile while many processes are still running)? Are
> you able to regularly trigger it?

Hi, sorry, I missed your reply, Michael just gave me a wake-up call.

I can't tell that much about the workload, I don't have access to it
either, let's say that from my point of view it's a "customer" binary
blob.

I can re-trigger it though.

> > I think the right sequence however requires breaking up end_sync. Ie, we
> > need to do in that order:
> > 
> >   - cancel the workqueues
> >   - unregister the notifier
> >   - process the mortuary
> > 
> > What do you think ?
> 
> This could potentially fix it, I will have to look deeper into the
> code. Try to do this next week.

Thanks. Let me know.

Cheers,
Ben.


