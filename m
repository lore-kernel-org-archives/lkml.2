Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab2ENRDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:03:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57667 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab2ENRDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:03:36 -0400
MIME-Version: 1.0
In-Reply-To: <4FAD840D.9020009@gmail.com>
References: <CAEtiSau7w+aUf_pK39JS+-SgRRqHav4b1UZMiNFHCJTNPfN7EQ@mail.gmail.com>
	<4FAD840D.9020009@gmail.com>
Date: Mon, 14 May 2012 22:33:35 +0530
Message-ID: <CAEtiSauZg+sqZ01S0qcqEJsmmgTB3cZvnK-pC6NUerb40TB5rA@mail.gmail.com>
Subject: Re: [RFC][PATCH] mm: Update zone->un_reclaimable in direct reclaim path
From: Aaditya Kumar <aaditya.kumar.30@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: linux-kernel@vger.kernel.org, frank.rowand@am.sony.com,
        tim.bird@am.sony.com, takuzo.ohara@ap.sony.com,
        kan.iibuchi@jp.sony.com, kosaki.motohiro@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kosaki-san,

Konnichiwa,

> Today I don't have a time and I didn't read your patch. but I would say my
> patch
> passed my hotplug test. so can you please tell us your test case and
> reproducer?

My test case is as follows:
 1. Boot the kernel with 4 memory sections of 16MB each and each
belonging to a different NUMA node.
     We use 48MB for non movable memory ('kernelcore='). Also we do
NOT use swap devices.

 2. Execute a program that hogs memory (to be more precise, does
malloc()+ memset() on 70%
    of the total memory) and then sleeps.

 3. Try to offline all the memory sections one by one.

 On my board the kernel hangs in step three. From my debugging, I
found it is due to
 an infinite loop in direct reclaim path because in above test case
condition the
 zone->unreclaimable is not set, even though almost all pages are in
ISOLATED state.

 I am using a board not supported in mainline kernel but since the
code path of the
 problem is arch independent So I thought above test case should
reproduce on other
 architectures too and may be the patch can be helpful.

 Just FYI:
 We are using a modified kernel where we use different NUMA nodes for
different type
 of memory allocation (based on speed, readable-writable ,etc ) on
ARM. But these
 modifications are independent of code path of patch and we believe it
is independent of the
 problem.

Regards,
Aaditya Kumar.
Sony India Software Centre.

On Sat, May 12, 2012 at 2:56 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> (5/11/12 4:35 AM), Aaditya Kumar wrote:
>>
>> Dear All,
>>
>>  Commit 929bea7c714220fc76ce3f75bef9056477c28e74 seems to have broken the
>>  OOM invocation during memory hot unplug in low memory conditions. This
>> commit
>>  modifies the 'un-reclaimabilty check'  for  giving up trying to
>> reclaim pages in the
>> direct reclaim path and invoke OOM  killer to be based on
>> zone->unreclaimable.
>
>
> Today I don't have a time and I didn't read your patch. but I would say my
> patch
> passed my hotplug test. so can you please tell us your test case and
> reproducer?
>
> I'll look into closely later.
>
>
>
