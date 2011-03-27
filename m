Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab1C0J55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 05:57:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab1C0J54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 05:57:56 -0400
Message-ID: <4D8F09EF.3020002@redhat.com>
Date: Sun, 27 Mar 2011 11:57:03 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
References: <alpine.DEB.2.00.1103221635400.4521@tiger>  <20110324142146.GA11682@elte.hu>  <alpine.DEB.2.00.1103240940570.32226@router.home>  <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>  <20110324172653.GA28507@elte.hu>  <alpine.DEB.2.00.1103241242450.32226@router.home>  <AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com>  <alpine.DEB.2.00.1103241300420.32226@router.home>  <AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com>  <alpine.DEB.2.00.1103241312280.32226@router.home> <1300990853.3747.189.camel@edumazet-laptop> <alpine.DEB.2.00.1103241346060.32226@router.home>
In-Reply-To: <alpine.DEB.2.00.1103241346060.32226@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 08:47 PM, Christoph Lameter wrote:
> On Thu, 24 Mar 2011, Eric Dumazet wrote:
>
> >  >  this_cpu_cmpxchg16b_emu:
> >  >          pushf
> >  >          cli
> >  >
> >  >          cmpq %gs:(%rsi), %rax
>
> >  Random guess
> >
> >  Masking interrupts, and accessing vmalloc() based memory for the first
> >  time ?
>
> Hmmm.. Could be. KVM would not really disable interrupts so this may
> explain that the test case works here.

kvm does really disable guest interrupts (it doesn't disable host 
interrupts, but these are invisible to the guest).

-- 
error compiling committee.c: too many arguments to function

