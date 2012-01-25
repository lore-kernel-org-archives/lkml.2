Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab2AYPzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 10:55:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39157 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab2AYPzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 10:55:38 -0500
Subject: Re: [PATCH v2] sched: Accelerate "pick_next_entity" under special
 condition
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>, ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4F14E54E.80904@linux.vnet.ibm.com>
References: <4F13EFBE.1030002@linux.vnet.ibm.com>
	 <1326707503.2442.219.camel@twins>	<4F14DEAE.60702@linux.vnet.ibm.com>
	 <CAJn8CcHhaSA5kF9KVjMorzt_2NM-dTPc5mTr3-A9GvR54VRo=A@mail.gmail.com>
	 <4F14E54E.80904@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Jan 2012 16:55:34 +0100
Message-ID: <1327506934.2614.87.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 11:04 +0800, Michael Wang wrote:
> 
> > Then what if condition 1 is true now?
> 
> We can see in original code, even condition 1 is true, we
> still will use value3 if condition3 is true, like this:
> 
> original:
> 
> condition1      condition3      result
> true            true            value3
> true            false           value1
> 
> That means if condition3 is true, we don't care whether
> condition1 is true or not because we will finally use value3.

Right, so from the original 8 possible states we used to evaluate 3*8 =
24 conditionals. The new code will reduce this to 1*4 + 2*2 + 2*3 = 14.

Now I guess the question is if it matters for the modal or average
state.

I've applied the patch since it can't be worse, but I've no idea if it
matters or not in practice.

