Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab0LUXZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:25:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53233 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab0LUXZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:25:39 -0500
Message-ID: <4D11373D.9010205@zytor.com>
Date: Tue, 21 Dec 2010 15:24:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 1/4] Generic support for this_cpu_cmpxchg_double
References: <20101214174847.887713690@linux.com> <20101214174900.058235985@linux.com> <4D0CC982.3030905@kernel.org> <alpine.DEB.2.00.1012211634560.3769@router.home>
In-Reply-To: <alpine.DEB.2.00.1012211634560.3769@router.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 02:36 PM, Christoph Lameter wrote:
> On Sat, 18 Dec 2010, Tejun Heo wrote:
> 
>> pointers from the beginning.  Anyways, that's too late, so is it
>> completely impossible to make cmpxchg_double's take a scalar value?
>> It can take the pointer all the same, no?
> 
> It could take a scalar value like the others but we are then not operating
> on the scalar alone but also on the following field.
> 

I'm a bit confused on this one.  The standard cmpxchg() takes a scalar
and a pointer, and returns a scalar.  The equivalent for the "double"
variety would be to return a compound object, basically:

struct double_ulong {
	unsigned long v[2];
};

... which can be returned in registers on both i386 and x86-64.

It's a bit clumsy from a type perspective, but I'm not sure that that is
a bad thing.  Doing too much type genericity has caused us problems in
the past.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

