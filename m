Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab0GYHmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 03:42:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:57786 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab0GYHmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 03:42:07 -0400
Message-ID: <4C4BEAA2.6040301@kernel.org>
Date: Sun, 25 Jul 2010 09:41:22 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, Sridhar Samudrala <sri@us.ibm.com>,
        netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH UPDATED 1/3] vhost: replace vhost_workqueue with per-vhost
 kthread
References: <4BFFE742.2060205@kernel.org> <20100530112925.GB27611@redhat.com> <4C02C961.9050606@kernel.org> <20100531152221.GB2987@redhat.com> <4C03D983.9010905@kernel.org> <20100531160020.GC3067@redhat.com> <4C04D41B.4050704@kernel.org> <4C06A580.9060300@kernel.org> <20100722155840.GA1743@redhat.com> <4C48B664.9000109@kernel.org> <20100724191447.GA4972@redhat.com>
In-Reply-To: <20100724191447.GA4972@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 25 Jul 2010 07:41:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/24/2010 09:14 PM, Michael S. Tsirkin wrote:
>> I've created kthread_worker in wq#for-next tree and already converted
>> ivtv to use it.  Once this lands in mainline, I think converting vhost
>> to use it would be better choice.  kthread worker code uses basically
>> the same logic used in the vhost_workqueue code but is better
>> organized and documented.  So, I think it would be better to stick
>> with the original implementation, as otherwise we're likely to just
>> decrease test coverage without much gain.
>>
>>   http://git.kernel.org/?p=linux/kernel/git/tj/wq.git;a=commitdiff;h=b56c0d8937e665a27d90517ee7a746d0aa05af46;hp=53c5f5ba42c194cb13dd3083ed425f2c5b1ec439
> 
> Sure, if we keep using workqueue. But I'd like to investigate this
> direction a bit more because there's discussion to switching from kthread to
> regular threads altogether.

Hmmm? It doesn't have much to do with workqueue.  kthread_worker is a
simple wrapper around kthread.  It now assumes kthread but changing it
to be useable with any thread shouldn't be too hard.  Wouldn't that be
better?

>> I don't think doing this before executing the function is correct,
> 
> Well, before I execute the function work is NULL, so this is skipped.
> Correct?
>
>> so
>> you'll have to release the lock, execute the function, regrab the lock
>> and then do the flush processing.
>>
>> Thanks.
> 
> It's done in the loop, so I thought we can reuse the locking
> done for the sake of processing the next work item.
> Makes sense?

Yeap, right.  I think it would make much more sense to use common code
when it becomes available but if you think the posted change is
necessary till then, please feel free to go ahead.

Thanks.

-- 
tejun
