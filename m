Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab0DPV1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 17:27:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:60690 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab0DPV1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 17:27:34 -0400
Subject: Re: Possible bug with mutex adaptative spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <1271213767.13059.137.camel@pasglop>
References: <1271212509.13059.135.camel@pasglop>
	 <1271213767.13059.137.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 23:27:31 +0200
Message-ID: <1271453251.1674.485.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 12:56 +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2010-04-14 at 12:35 +1000, Benjamin Herrenschmidt wrote:
> > Hi Peter !
> > 
> > I -may- have found a bug with mutex adaptative spinning. We hit it when
> > torture testing CPU unplug.
> 
>  .../...
> 
> In fact, I wonder if there's another potential problem:
> 
> If the owner is actually running, it may do so for a very long time. It
> looks to me that everybody trying to take the mutex will thus spin and
> never get out of the spin loop until the owner stops running.

The inner-most spin loop breaks out on need_resched():

                if (task_thread_info(rq->curr) != owner || need_resched())
                        return 0;


