Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0LHRRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:17:33 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51439 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab0LHRRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:17:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=opUyS08VzRsh5aMmkWPI2B3cD+8wymtFNH9vZHnkkOU5qMClnawScqzANOADIC7uu1
         RsbXv3CH2kp1eF+yRCscITP76YkxtoeBcOsNARKLHPjY0mblX64cxcGoE7rQ2QwF6qKH
         K9IGdqjWD5k0KLMLyT1uTzA7nixFnqB/14cLs=
Subject: Re: [PATCH] x86: Replace uses of current_cpu_data with this_cpu ops
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <alpine.DEB.2.00.1012080929590.23407@router.home>
References: <20101206171618.302060721@linux.com>
	 <20101206171638.595205962@linux.com> <4CFE41F8.7040400@kernel.org>
	 <4CFE4294.30001@kernel.org>
	 <alpine.DEB.2.00.1012070846050.25976@router.home>
	 <4CFE4BE0.9040203@kernel.org>
	 <alpine.DEB.2.00.1012070906290.26552@router.home>
	 <4CFE4E05.7070902@kernel.org>
	 <alpine.DEB.2.00.1012071020040.26552@router.home>
	 <4CFF8520.4020704@kernel.org> <1291815501.2883.34.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1012080929590.23407@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 18:17:26 +0100
Message-ID: <1291828646.2883.65.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 08 décembre 2010 à 09:33 -0600, Christoph Lameter a écrit :
> On Wed, 8 Dec 2010, Eric Dumazet wrote:
> 
> > > In the long run, it might be a good idea to remove cpu_data() macro
> > > too and use per_cpu macro directly.
> > >
> >
> > or introduce this_cpu_has() to remove the adress computation
> >
> > -	if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_ARAT)) {
> >
> > +	if (this_cpu_has(X86_FEATURE_ARAT)) {
> >
> 
> The fundamental problem is that bitops require memory addresses which does
> not work with per cpu ops.
> 

Sure, set() or clear() needs the address, but the read doesnt ?

This can be implemented as

  (__this_cpu_read(cpu_info.word[X]) & MASK)

Anyway, even if mapped to cpu_has(__this_cpu_ptr(&cpu_info), XXX), 
it would be cleaner to use this_cpu_has() helper.



