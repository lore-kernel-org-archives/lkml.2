Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1DIHke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 03:40:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46375 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab1DIHkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 03:40:33 -0400
Date: Sat, 9 Apr 2011 09:40:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Pekka Enberg <penberg@kernel.org>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, kvm@vger.kernel.org, joro@8bytes.org,
        penberg@cs.helsinki.fi, asias.hejun@gmail.com, gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-ID: <20110409074009.GA25729@elte.hu>
References: <4D982E89.8070502@redhat.com>
 <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
 <4D9847BC.9060906@redhat.com>
 <4D98716D.9040307@codemonkey.ws>
 <4D9873CD.3080207@redhat.com>
 <20110406093333.GB6465@elte.hu>
 <4D9E6F6E.9050709@codemonkey.ws>
 <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
 <4D9F150B.1030809@codemonkey.ws>
 <20110408192039.GJ29444@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408192039.GJ29444@random.random>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrea Arcangeli <aarcange@redhat.com> wrote:

> [...] I thought the whole point of a native kvm tool was to go all the 
> paravirt way to provide max performance and maybe also depend on vhost as 
> much as possible.

To me it's more than that: today i can use it to minimally boot test various 
native bzImages just by typing:

	kvm run ./bzImage

this will get me past most of the kernel init, up to the point where it would 
try to mount user-space. ( That's rather powerful to me personally, as i 
introduce most of my bugs to these stages of kernel bootup - and as a kernel 
developer i'm not alone there ;-)

I would be sad if i were forced to compile in some sort of paravirt support, 
just to be able to boot-test random native kernel images.

Really, if you check the code, serial console and timer support is not a big 
deal complexity-wise and it is rather useful:

  git pull git://github.com/penberg/linux-kvm master

So i think up to a point hardware emulation is both fun to implement (it's fun 
to be on the receiving end of hw calls, for a change) and a no-brainer to have 
from a usability POV. How far it wants to go we'll see! :-)

Thanks,

	Ingo
