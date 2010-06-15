Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab0FOBUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 21:20:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57897 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab0FOBUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 21:20:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LMbO1CWnexNEEhP+N7aseggG2q++EIXWjQ3Ah7BrSLcwn+U+ejFWmYNaifyXZC90yl
         JYth2vRqOmIniY26Tpzz3ai7pCcr/Ztcp3XAad7m1kfL+0O+mLDcl2G/gO9bnqaeK3D7
         pkU2Yi3ucATMPivqJ+cA1q0jT2S5Dacz2xqeM=
Message-ID: <4C16D55E.6040701@garzik.org>
Date: Mon, 14 Jun 2010 21:20:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#5
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 05:37 PM, Tejun Heo wrote:
> Hello, all.
>
> This is the fifth take of cmwq (concurrency managed workqueue)
> patchset.  It's on top of v2.6.35-rc3 + sched/core patches.  Git tree
> is available at
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-cmwq
>
> Changes from the last take[L] are...
>
> * fscache patches are omitted for now.
>
> * The patchset is rebased on cpu_stop + sched/core, which now includes
>    all the necessary scheduler patches.  cpu_stop already reimplements
>    stop_machine so that it doesn't use RT workqueue, so this patchset
>    simply drops RT wq support.
>
> * __set_cpus_allowed() was determined to be unnecessary with recent
>    scheduler changes.  On cpu re-onlining, cmwq now kills all idle
>    workers and tells busy ones to rebind after finishing the current
>    work by scheduling a dedicated work.  This allows managing proper
>    cpu binding without adding overhead to hotpath.
>
> * Oleg's clear work->data patch moved at the head of the queue and now
>    lives in the for-next branch which will be pushed to mainline on the
>    next merge window.
>
> * Applied Oleg's review.
>
>    * Comments updated as suggested.
>
>    * work_flags_to_color() replaced w/ get_work_color()
>
>    * nr_cwqs_to_flush bug which could cause premature flush completion
>      fixed.
>
>    * Replace rewind + list_for_each_entry_safe_continue() w/
>      list_for_each_entry_safe_from().
>
>    * Don't directly write to *work_data_bits() but use __set_bit()
>      instead.
>
>    * Fixed cpu hotplug exclusion bug.
>
> * Other misc tweaks.
>
> Now that all scheduler bits are in place, I'll keep the tree stable
> and publish it to linux-next soonish, so this hopefully is the last of
> exhausting massive postings of this patchset.
>
> Jeff, Arjan, I think it'll be best to route the libata and async
> patches through wq tree.  Would that be okay?

ACK for libata bits routing through wq tree...  you know I support this 
work, as libata (and the kernel, generally speaking) has needed 
something like this for a long time.


