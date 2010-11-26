Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0KZQ4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:56:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42280 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0KZQ4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:56:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=h/Qen2Rt8GCqz05QS5h0PHdek1dy2vjvaAyea/HyMuaPuf4yGSu89gnq7k1p0UTURb
         vpru0Xy/pGWylqA7lhhpm2GhCH6xchg8+YVYXWUSGmFlkeJah64n0UVijZ6yNtyHMR5M
         DNssUXe6GrAgez3cYXyEA0wprz0GRlV5FaKlM=
Subject: Re: [thiscpuops upgrade 08/10] percpu: generic this_cpu_cmpxchg()
 and this_cpu_cmpxchg_double support
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <4CEFE583.8070103@kernel.org>
References: <20101123235139.908255844@linux.com>
	 <20101123235200.582485207@linux.com>  <4CEFE583.8070103@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 17:56:09 +0100
Message-ID: <1290790569.2855.254.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 26 novembre 2010 à 17:51 +0100, Tejun Heo a écrit :
> On 11/24/2010 12:51 AM, Christoph Lameter wrote:
> > +/*
> > + * cmpxchg_double replaces two adjacent scalars at once. The first parameter
> > + * passed is a percpu pointer, not a scalar like the other this_cpu
> > + * operations. This is so because the function operates on two scalars
> > + * (must be of same size). A truth value is returned to indicate success or
> > + * failure (since a double register result is difficult to handle).
> > + * There is very limited hardware support for these operations. So only certain
> > + * sizes may work.
> > + */
> > +#define __this_cpu_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)	\
> 
> Ah... this is scary.  If it proves to be useful enough, sure, but
> otherwise I'd like to avoid it.
> 

This is mandatory for several lockless algos, dont be afraid, its a
single instruction ;)



