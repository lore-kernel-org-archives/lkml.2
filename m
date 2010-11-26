Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0KZRQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:16:28 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46054 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab0KZRQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:16:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=T0pCRCyjAVI4jEhrr/QfLELG0Ib1jwkiNh+wwBWIJD6TQb+bnCQKdHD6JTzi2m7Z4e
         nr2iVwIlbyB7GHOas6jgkoY2Y+PMGPO5Frm5JFfpMvB9nBu/3XChiZMbO2jRRJyGO5ou
         5O3yc+LdxNvqEJQoMOMyuLOE317IaVs5FAVmc=
Subject: Re: [thiscpuops upgrade 08/10] percpu: generic this_cpu_cmpxchg()
 and this_cpu_cmpxchg_double support
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <4CEFE958.2020606@kernel.org>
References: <20101123235139.908255844@linux.com>
	 <20101123235200.582485207@linux.com>  <4CEFE583.8070103@kernel.org>
	 <1290790569.2855.254.camel@edumazet-laptop>  <4CEFE71F.5090303@kernel.org>
	 <1290790887.2855.260.camel@edumazet-laptop>  <4CEFE958.2020606@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 18:16:16 +0100
Message-ID: <1290791776.2855.262.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 26 novembre 2010 à 18:07 +0100, Tejun Heo a écrit :
> On 11/26/2010 06:01 PM, Eric Dumazet wrote:
> >> What I'm afraid of is generic code switching to use it in very hot
> >> paths when a lot of archs can't actually do it leading to performance
> >> regressions.  Is this something which is available on most archs?
> >>
> > 
> > I would say cmpxchg() has the same problem, some arches dont have a
> > native instruction, yet we use it in some paths.
> 
> Yeah, well, there's difference between some not having it and only
> x86_64 having it.  cmpxchg was already rather well received when it
> was added even though it wasn't available on all archs.  I'm not
> against it but think we should use some caution here and think about
> the impact of unoptimized cases which can be pretty common (preemption
> toggling isn't too expensive but irq toggling can be quite).
> 


x86_32 has it too

x86_64 uses cmpxchg16b, while x86_32 uses cmpxhg8b


And I guess it will be used in contexts we had to disable irqs, so it
will be faster on x86, and same cost on other arches.



