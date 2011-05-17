Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1EQNA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:00:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44381 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab1EQNA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:00:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QUKb/Q/JrA7uz+8fHFdmax2WfxaMie8YM/RACHTghwiE4kEBcQ1jfYF4NPxNeNYt3p
         uXd4JmOELZ3ylJU1WzXNgq9lfim9JGWE1O3R4Rg9kQbM9XSw4Hv1a454izk0pCAF4rY3
         Ajx+sace5S0QNLkbmnwcH0CvdgtBnXNTivmKc=
Subject: Re: [patch V3] percpu_counter: scalability works
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <20110517124528.GN20624@htj.dyndns.org>
References: <1305538504.2898.33.camel@edumazet-laptop>
	 <1305555736.2898.46.camel@edumazet-laptop>
	 <1305593751.2375.69.camel@sli10-conroe>
	 <1305608212.9466.45.camel@edumazet-laptop>
	 <1305609768.2375.84.camel@sli10-conroe>
	 <1305622861.2850.21.camel@edumazet-laptop>
	 <20110517091102.GE20624@htj.dyndns.org>
	 <1305625541.2850.29.camel@edumazet-laptop>
	 <20110517095001.GF20624@htj.dyndns.org>
	 <1305634807.2850.89.camel@edumazet-laptop>
	 <20110517124528.GN20624@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 15:00:23 +0200
Message-ID: <1305637223.2850.95.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 mai 2011 à 14:45 +0200, Tejun Heo a écrit :

> Given that _sum() is super-slow path and we have a lot of latitude
> there, 

Absolutely not. Its slow path yes, but not super-slow.

Dont change rules now ;)

Take a look at include/net/tcp.h and commit ad1af0fedba14f82b
(tcp: Combat per-cpu skew in orphan tests.)

If you guys make percpu_counter much slower, we'll just remove its use
in network stack, and there will be not a lot of users left.



