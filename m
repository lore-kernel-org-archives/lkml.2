Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2IXKjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:39:14 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:56372 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab2IXKjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:39:13 -0400
Message-ID: <50603829.9050904@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2012 16:08:33 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Conny Seidel <conny.seidel@amd.com>
Subject: Re: divide error: bdi_dirty_limit+0x5a/0x9e
References: <20120924102324.GA22303@aftab.osrc.amd.com>
In-Reply-To: <20120924102324.GA22303@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12092410-5816-0000-0000-00000497B468
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 03:53 PM, Borislav Petkov wrote:
> Hi all,
> 
> we're able to trigger the oops below when doing CPU hotplug tests.
> 

I hit this problem as well, which I reported here, a few days ago:
https://lkml.org/lkml/2012/9/13/222

<snip>

> 	...
> 
> and from looking at the register dump below, the dividend, which should
> be in %rdx:%rax is 0 and the divisor (denominator) we've got from
> bdi_writeout_fraction and is in %rdi is also 0. Which is strange because
> fprop_fraction_percpu guards for division by zero by setting denominator
> to 1 if it were zero but what about the case where den > num? Can that
> even happen?
> 
> And also, what happens if num is 0? Which it kinda is by looking at %rcx
> where there's copy of it.
>

Going by the usage of percpu_counter_read_positive() (which is used to get
both the values of num and den), the least value that num or den can have
is zero. So, the C code to guard against divide-by-zero looks OK to me.
Which unfortunately keeps the mystery unsolved :(

Regards,
Srivatsa S. Bhat
 

