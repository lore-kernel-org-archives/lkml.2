Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab1AUPdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:33:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48026 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab1AUPdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:33:25 -0500
Message-ID: <4D39A6EB.70705@zytor.com>
Date: Fri, 21 Jan 2011 07:31:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Christoph Lameter <cl@linux.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for this_cpu_cmpxchg_double
References: <20110106204513.669098445@linux.com> <20110106204525.222395863@linux.com> <4D263C91.30709@zytor.com> <alpine.DEB.2.00.1101070907060.3014@router.home> <20110107180419.GB23082@Krystal> <alpine.DEB.2.00.1101071227450.3014@router.home> <20110108172453.GF13269@mtj.dyndns.org> <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org>
In-Reply-To: <20110121092649.GA2832@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2011 01:26 AM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Jan 21, 2011 at 09:31:02AM +0200, Pekka Enberg wrote:
>> On 1/8/11 7:24 PM, Tejun Heo wrote:
>>> Call me weird but I like this one than others.  It sure is ugly but
>>> the operation itself isn't a particularly pretty so it kinda matches.
>>> Also, this one is the least error prone and more consistent with other
>>> cpu ops.
>>
>> So what are we going to do about this patch? I'd love to merge
>> Christoph's SLUB patches for linux-next now that .38-rc1 is out.
> 
> At least you like it, which is good.
> 
> I don't think the currently proposed one with two separate parameters
> is significantly better than other alternatives and vice-versa.  They
> all have slightly different ugliness and error proneness issues.
> 
> That said, I still like the double parameter one best, and, unless
> there are distinctively good reasons to choose another one, I'm gonna
> commit it to percpu tree in a few days so that merge can proceed.  So,
> if you have something to say, now would be a good time to assert it.
> 

I really object to passing two pointers where one of them has to be a
fixed offset to the other.  That really doesn't make any sense.

	-hpa
