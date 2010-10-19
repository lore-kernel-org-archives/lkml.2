Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab0JSNX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:23:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:2684 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758484Ab0JSNXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:23:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,350,1283756400"; 
   d="scan'208";a="337832239"
Message-ID: <4CBD9BCA.2060200@linux.intel.com>
Date: Tue, 19 Oct 2010 15:23:22 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Andi Kleen <andi@firstfloor.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix array overflow in CFQ
References: <1287479450-11447-1-git-send-email-andi@firstfloor.org> <4CBD6C84.3020309@kernel.dk> <20101019114933.GA857@redhat.com> <20101019123320.GB857@redhat.com>
In-Reply-To: <20101019123320.GB857@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>          slice = group_slice * count /
>                  max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
>                        cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd,
> cfqg));
>
> So for IDLE class, we return immediately from the function and never
> execute cfqg->busy_queues_avg[IDLE].

Hmm that's true. But why do you put this into a global variable anyways, 
can't it
just be a local?
> Now to remove the gcc warning we can increase the size of busy_queues_avg[]
> array but third field should always remain unused.
>
It's better to increase the field still I think.

-Andi

