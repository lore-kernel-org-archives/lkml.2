Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0CUTR6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 15:17:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54700 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0CUTR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 15:17:56 -0400
Date: Sun, 21 Mar 2010 20:17:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100321191742.GD25922@elte.hu>
References: <4BA250BF.80704@codemonkey.ws>
 <20100318162853.GB447@elte.hu>
 <4BA256FE.5080501@codemonkey.ws>
 <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com>
 <20100318170223.GB9756@elte.hu>
 <4BA25E66.2050800@redhat.com>
 <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
 <20100319085346.GG12576@elte.hu>
 <4BA3747F.60401@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA3747F.60401@codemonkey.ws>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anthony Liguori <anthony@codemonkey.ws> wrote:

> On 03/19/2010 03:53 AM, Ingo Molnar wrote:
> >* Avi Kivity<avi@redhat.com>  wrote:
> >
> >>>There were two negative reactions immediately, both showed a fundamental
> >>>server versus desktop bias:
> >>>
> >>>  - you did not accept that the most important usecase is when there is a
> >>>    single guest running.
> >>Well, it isn't.
> >Erm, my usability points are _doubly_ true when there are multiple guests ...
> >
> >The inconvenience of having to type:
> >
> >   perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms \
> >   --guestmodules=/home/ymzhang/guest/modules top
> >
> >is very obvious even with a single guest. Now multiply that by more guests ...
> 
> If you want to improve this, you need to do the following:
> 
> 1) Add a userspace daemon that uses vmchannel that runs in the guest and can 
>    fetch kallsyms and arbitrary modules.  If that daemon lives in 
>    tools/perf, that's fine.

Adding any new daemon to an existing guest is a deployment and usability 
nightmare.

The basic rule of good instrumentation is to be transparent. The moment we 
have to modify the user-space of a guest just to monitor it, the purpose of 
transparent instrumentation is defeated.

That was one of the fundamental usability mistakes of Oprofile.

There is no 'perf' daemon - all the perf functionality is _built in_, and for 
very good reasons. It is one of the main reasons for perf's success as well.

Now Qemu is trying to repeat that stupid mistake ...

So please either suggest a different transparent solution that is technically 
better than the one i suggested, or you should concede the point really.

Please try think with the heads of our users and developers and dont suggest 
some weird ivory-tower design that is totally impractical ...

And no, you have to code none of this, we'll do all the coding. The only thing 
we are asking is for you to not stand in the way of good usability ...

Thanks,

	Ingo
