Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab0CUUKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:10:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231Ab0CUUKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:10:14 -0400
Message-ID: <4BA67D0B.9030705@redhat.com>
Date: Sun, 21 Mar 2010 22:09:47 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Antoine Martin <antoine@nagafix.co.uk>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
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
References: <4BA256FE.5080501@codemonkey.ws> <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com> <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA674F1.6070603@nagafix.co.uk> <20100321195903.GA29490@elte.hu>
In-Reply-To: <20100321195903.GA29490@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 09:59 PM, Ingo Molnar wrote:
>
> Frankly, i was surprised (and taken slightly off base) by both Avi and Anthony
> suggesting such a clearly inferior "add a demon to the guest space" solution.
> It's a usability and deployment non-starter.
>    

It's only clearly inferior if you ignore every consideration against 
it.  It's definitely not a deployment non-starter, see the tons of 
daemons that come with any Linux system.  The basic ones are installed 
and enabled automatically during system installation.

> Furthermore, allowing a guest to integrate/mount its files into the host VFS
> space (which was my suggestion) has many other uses and advantages as well,
> beyond the instrumentation/symbol-lookup purpose.
>    

Yes.  I'm just not sure about the auto-enabling part.

> So can we please have some resolution here and move on: the KVM maintainers
> should either suggest a different transparent approach, or should retract the
> NAK for the solution we suggested.
>    

So long as you define 'transparent' as in 'only the guest kernel is 
involved' or even 'only the guest and host kernels are involved' we 
aren't going to make a lot of progress.  I oppose shoving random bits of 
functionality into the kernel, especially things that are in daily use.  
While us developers do and will use profiling extensively, it doesn't 
need sit in every guest's non-swappable .text.

> We very much want to make progress and want to write code, but obviously we
> cannot code against a maintainer NAK, nor can we code up an inferior solution
> either.
>    

You haven't heard any NAKs, only objections.  If we discuss things 
perhaps we can achieve something that works for everyone.  If we keep 
turning the flames higher that's unlikely.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

