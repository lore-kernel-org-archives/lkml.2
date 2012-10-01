Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab2JAICV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:02:21 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39104 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab2JAICR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:02:17 -0400
Message-ID: <50694D3C.8000603@parallels.com>
Date: Mon, 1 Oct 2012 11:58:52 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
References: <1348571866-31738-1-git-send-email-glommer@parallels.com> <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com> <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com> <5062C029.308@parallels.com> <alpine.DEB.2.00.1209261813300.7072@chino.kir.corp.google.com> <5063F94C.4090600@parallels.com> <alpine.DEB.2.00.1209271552350.13360@chino.kir.corp.google.com> <0000013a0d390e11-03bf6f97-a8b7-4229-9f69-84aa85795b7e-000000@email.amazonses.com> <alpine.DEB.2.00.1209281336380.21335@chino.kir.corp.google.com> <CAOJsxLFYSKqq-JexK1Q7NEtQmxtJnWB-WwbNyp9tk9mpAh6vGg@mail.gmail.com>
In-Reply-To: <CAOJsxLFYSKqq-JexK1Q7NEtQmxtJnWB-WwbNyp9tk9mpAh6vGg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 11:28 AM, Pekka Enberg wrote:
> Hello,
> 
> [ Found this in my @cs.helsinki.fi inbox, grmbl. ]
> 
> On Fri, Sep 28, 2012 at 11:39 PM, David Rientjes <rientjes@google.com> wrote:
>> The first prototype, SLAM XP1, will be posted in October.  I'd simply like
>> to avoid reverting this patch down the road and having all of us
>> reconsider the topic again when clear alternatives exist that, in my
>> opinion, make the code cleaner.
> 
> David, I'm sure you know we don't work speculatively against
> out-of-tree code that may or may not be include in the future...
> 
> That said, I don't like Glauber's patch because it leaves CREATE_MASK
> in mm/slab.c. And I'm not totally convinced a generic SLAB_INTERNAL is
> going to cut it either. Hmm.
> 
>                         Pekka
> 

How about we require allocators to define their own CREATE_MASK, and
then in slab_common.c we mask out any flags outside that mask?

This way we can achieve masking in common code while still leaving the
decision to the allocators.

