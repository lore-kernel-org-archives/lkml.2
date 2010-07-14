Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab0GNJjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:39:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:45553 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab0GNJjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:39:23 -0400
Message-ID: <4C3D8570.4080902@kernel.org>
Date: Wed, 14 Jul 2010 11:37:52 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Yong Zhang <yong.zhang@windriver.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
        cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
        oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
        dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
        andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCH] workqueue: fix locking in retry path of maybe_create_worker()
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-28-git-send-email-tj@kernel.org> <20100709091138.GA7304@windriver.com> <4C3AD7FE.2050702@kernel.org> <20100712132347.GA19305@windriver.com>
In-Reply-To: <20100712132347.GA19305@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Jul 2010 09:37:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 03:23 PM, Yong Zhang wrote:
> On Mon, Jul 12, 2010 at 10:53:18AM +0200, Tejun Heo wrote:
>> maybe_create_worker() mismanaged locking when worker creation fails
>> and it has to retry.  Fix locking and simplify lock manipulation.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Reported-by: Yong Zhang <yong.zhang@windriver.com>
>> ---
>> Heh, that was stupid.  Thanks a lot for spotting it.  I simplified
>> things a bit there as there's no reason to repeatedly lock and unlock
>> there.  Does this look good to you?
> 
> Yeah, this is better.

Pushed out to for-next-candidate branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-next-candidate

I'll push it to linux-next the next week.

Thanks.

-- 
tejun
