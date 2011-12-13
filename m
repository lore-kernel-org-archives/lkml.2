Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab1LMX0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 18:26:30 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:63762 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab1LMX02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 18:26:28 -0500
Message-ID: <4EE7DF0F.4030506@oracle.com>
Date: Tue, 13 Dec 2011 17:26:07 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] AIO: Don't plug the I/O queue in do_io_submit()
References: <4EE7C74D.1020306@oracle.com> <x49sjkoi08u.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49sjkoi08u.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4EE7DF1B.0049,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2011 04:18 PM, Jeff Moyer wrote:
> Dave Kleikamp <dave.kleikamp@oracle.com> writes:
> 
>> Asynchronous I/O latency to a solid-state disk greatly increased
>> between the 2.6.32 and 3.0 kernels. By removing the plug from
>> do_io_submit(), we observed a 34% improvement in the I/O latency.
>>
>> Unfortunately, at this level, we don't know if the request is to
>> a rotating disk or not.
> 
> I'm guessing I know the answer to this, but what workload were you
> testing, and can you provide more concrete evidence than "latency
> greatly increased?"

It is a piece of a larger industry-standard benchmark and you're
probably guessing correctly. The "greatly increased" latency was
actually slightly higher the improvement I get with this patch. So the
patch brought the latency nearly down to where it was before.

 I will try a microbenchmark to see if I get similar behavior, but I
wanted to throw this out here to get input.

I also failed to mention that the earlier kernel was a vendor kernel
(similar results on both Redhat and Oracle kernels). The 3.0 kernel is
much closer to mainline, but I haven't played with mainline kernels yet.
I expect similar results, but I can verify that.

> Also, have you tested the effects this has when
> using traditional storage for whatever your workload is?

That may be difficult, but hopefully, I can demonstrate it with a
simpler benchmark which I could test on traditional storage.

> I don't feel
> comfortable essentially reverting a performance patch without knowing
> the entire picture.  I will certainly do some testing on my end, too.

Understood. Thanks,

Shaggy

> Cheers,
> Jeff
