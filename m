Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab0LVJOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 04:14:07 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:63621 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab0LVJOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 04:14:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e1jRtwAljuRekNx1Pw5XWtvtDX9AYuedFH5U40FF7hw4/iRKttxopLSC8eGril+E+g
         aeIRFQrTAVpww36DIqAr9ul9fetA3lF0lMXQ1UMJgecEPhE3nP0pC3QViZcuBbXp3MYU
         6osZbYS1SyZ9CAKyabfy/D+B9xSCS+/7eB4v4=
Date: Wed, 22 Dec 2010 10:14:00 +0100
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 1/4] Generic support for
 this_cpu_cmpxchg_double
Message-ID: <20101222091358.GC27861@htj.dyndns.org>
References: <20101214174847.887713690@linux.com>
 <20101214174900.058235985@linux.com>
 <4D0CC982.3030905@kernel.org>
 <alpine.DEB.2.00.1012211634560.3769@router.home>
 <4D11373D.9010205@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D11373D.9010205@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 21, 2010 at 03:24:45PM -0800, H. Peter Anvin wrote:
> On 12/21/2010 02:36 PM, Christoph Lameter wrote:
> > On Sat, 18 Dec 2010, Tejun Heo wrote:
> > 
> >> pointers from the beginning.  Anyways, that's too late, so is it
> >> completely impossible to make cmpxchg_double's take a scalar value?
> >> It can take the pointer all the same, no?
> > 
> > It could take a scalar value like the others but we are then not operating
> > on the scalar alone but also on the following field.

Yes, it's weird but the operation itself is weird enough and named
accordingly, so to me it seems like a much lesser problem than
breaking interface consistency with other this_cpu_ ops.

> I'm a bit confused on this one.  The standard cmpxchg() takes a scalar
> and a pointer, and returns a scalar.  The equivalent for the "double"
> variety would be to return a compound object, basically:
> 
> struct double_ulong {
> 	unsigned long v[2];
> };
> 
> ... which can be returned in registers on both i386 and x86-64.
> 
> It's a bit clumsy from a type perspective, but I'm not sure that that is
> a bad thing.  Doing too much type genericity has caused us problems in
> the past.

Yeah, the above might be better too.  Is there any reason to use
cmpxchg_double on anything smaller?

Thanks.

-- 
tejun
