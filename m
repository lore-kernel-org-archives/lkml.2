Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0GGRjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 13:39:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50722 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab0GGRjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 13:39:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OSlSM7yxWwVlhehlDiTxGE5rEkow6CBtSU/VXRLJiRBE4H2Z1Ff7QEhvHMkkLOz3Xl
         MQ8VU8bpwh6zixMpQdGeEEOwlv05z1srjWqn0V6/z3rZndVyHRtr5g14kDmoQ2aOgMZk
         TIbE7HV++yXm67/o28i+L7k5MBdDZTeBeeGzE=
MIME-Version: 1.0
In-Reply-To: <x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
	<x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 7 Jul 2010 19:39:49 +0200
Message-ID: <AANLkTikulpqCK169_bIiXrHQtZIhsQpp_siBIvnahCVn@mail.gmail.com>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 7, 2010 at 7:03 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> Hi Jens,
>> patch 8e55063 "cfq-iosched: fix corner cases in idling logic", is
>> suspected for some regressions on high end hardware.
>> The two patches from this series:
>> - [PATCH 1/2] cfq-iosched: fix tree-wide handling of rq_noidle
>> - [PATCH 2/2] cfq-iosched: RQ_NOIDLE enabled for SYNC_WORKLOAD
>> fix two issues that I have identified, related to how RQ_NOIDLE is
>> used by the upper layers.
>> First patch makes sure that a RQ_NOIDLE coming after a sequence of
>> possibly idling requests from the same queue on the no-idle tree will
>> clear the noidle_tree_requires_idle flag.
>> Second patch enables RQ_NOIDLE for queues in the idling tree,
>> restoring the behaviour pre-8e55063 patch.
>
> Hi, Corrado,
>
> I ran your kernel through my tests.  Here are the results, up against
> vanilla, deadline, and the blk_yield patch set:
>
Hi Jeff,
can you also add cfq with 8e55063 reverted to the testing mix?

>                 just    just
>                fs_mark  fio        mixed
> -------------------------------+--------------
> deadline        529.44   151.4 | 450.0    78.2
> vanilla cfq     107.88   164.4 |   6.6   137.2
> blk_yield cfq   530.82   158.7 | 113.2    78.6
> corrado cfq      80.82   138.1 |   4.5   130.7

So it doesn't seem to help. I wonder if other parts of that commit are
affecting those workloads.

>
> fs_mark results are in files/second, fio results are in MB/s.  All
> results are the average of 5 runs.  In order to get results for the
> mixed workload for both vanilla and Corrado's kernels, I had to extend
> the runtime from 30s to 300s.
>
> So, the changes proposed in this thread actually make performance worse
> across the board.
>
> I re-ran my tests against a RHEL 5 kernel (which is based on 2.6.18),
> and it shows that fs_mark performance is much better than stock CFQ in
> 2.6.35-rc3, and the mixed workload results are much the same as they are
> now (which is to say, the fs_mark process is completely starved by the
> sequential reader).  So, that problem has existed for a long time.
>
> I'm still in the process of collecting data from production servers and
> will report back with my findings there.

Thanks,
Corrado

>
> Cheers,
> Jeff
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
