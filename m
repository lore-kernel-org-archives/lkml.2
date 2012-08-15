Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab2HOOza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:55:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32907 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2HOOz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:55:29 -0400
Message-ID: <1345042516.31459.99.camel@twins>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Alex Shi <alex.shi@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 15 Aug 2012 16:55:16 +0200
In-Reply-To: <CADZ9YHhB_1ZeZM3WOFiz0kcx1ZR9iFO_R=Mst_w=QKXOi4Z9OQ@mail.gmail.com>
References: <5028F12C.7080405@intel.com>
	 <CADZ9YHhB_1ZeZM3WOFiz0kcx1ZR9iFO_R=Mst_w=QKXOi4Z9OQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 20:24 +0600, Rakib Mullick wrote:
> How do you plan to test this power saving scheme? Using powertop? Or,
> is there any other tools? 

We should start out simple enough that we can validate it by looking at
task placement by hand, eg. 4 tasks on a dual socket quad-core, should
only keep one socket awake.

We can also add an power aware evaluator to Linsched (another one of
those things that needs getting sorted).

And yeah, someone running with a power meter is of course king.

_BUT_ we shouldn't go off the wall with power meters as that very
quickly gets very specific to the system being measured.

We should really keep this thing as simple as possible while still
providing some benefit for all various architectures without tons of per
arch knobs and knowhow.
