Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab2BPB6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 20:58:10 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:62405 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756779Ab2BPB6I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 20:58:08 -0500
MIME-Version: 1.0
In-Reply-To: <87k43nbsli.fsf@rustcorp.com.au>
References: <4F3B8EAE.4050809@linux.vnet.ibm.com>
	<20120215130240.7308f373.akpm@linux-foundation.org>
	<87k43nbsli.fsf@rustcorp.com.au>
Date: Wed, 15 Feb 2012 17:58:07 -0800
Message-ID: <CABeCy1advFb8QpX5wDBYo0_N8Rtu2=G88kCC2_KVyw=w7pNdzw@mail.gmail.com>
Subject: Re: [PATCH v2] arch/ia64: remove references to cpu_*_map.
From: Venki Pallipadi <venki@google.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mike Travis <travis@sgi.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 3:10 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Wed, 15 Feb 2012 13:02:40 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Wed, 15 Feb 2012 16:23:34 +0530
>> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>>
>> > This patch ought to go along with the patchsets that do cleanups in other
>> > architectures as well.. And it looks like Rusty's patchset[1] is a superset of
>> > Venki's patchset[2].. So, Rusty, would you kindly take this patch into your
>> > patchset? (It should come before the 11/12 in your patchset. This should apply
>> > at that point easily, because I have modified it to suit your 11/12 which also
>> > touches ia64).
>>
>> OK, I'm officially all confused.  I think I'll drop everything and wait
>> until it settles down.  Please, someone prepare a single patch series.
>>
>> The cpumask-related patches whcih I'm currently holding are:
>>
>> smp-introduce-a-generic-on_each_cpu_mask-function.patch
>> #arm-move-arm-over-to-generic-on_each_cpu_mask.patch: fold
>> arm-move-arm-over-to-generic-on_each_cpu_mask.patch
>> #tile-move-tile-to-use-generic-on_each_cpu_mask.patch: fold
>> tile-move-tile-to-use-generic-on_each_cpu_mask.patch
>> smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
>> smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
>> smp-add-func-to-ipi-cpus-based-on-parameter-func-update.patch
>> smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
>> smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
>> smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
>> slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
>> fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
>> mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch
>> mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update.patch
>> mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9.patch
>> #
>> arch-ia64-remove-references-to-cpu__map.patch
>> cpumask-avoid-mask-based-num_possible_cpus-and-num_online_cpus.patch
>>
>> So I'm thinking the thing to do is to drop just the final two?
>
> Keep them all, I'll rebase on top of linux-next, and send you a few
> patches.  I'm not going to break down by arch, that was just in the hope
> that the arch maintainers themselves would take them...
>

Rusty,
Can you include
cpumask-avoid-mask-based-num_possible_cpus-and-num_online_cpus.patch
from akpm's list as last patch in your series and with Andrew dropping
it. That will make sure things doesn't break in some intermediate
state.

Thanks,
Venki
