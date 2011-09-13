Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab1IMHkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 03:40:13 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64132 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab1IMHkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 03:40:11 -0400
Date: Tue, 13 Sep 2011 16:40:04 +0900
From: Tejun Heo <tj@kernel.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: What is the difference between percpu_xxx and this_cpu_xxx?
Message-ID: <20110913074004.GA11397@mtj.dyndns.org>
References: <4E6EDBFB.4010705@intel.com>
 <1315894267.2556.21.camel@edumazet-laptop>
 <4E6EF4AE.4030503@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E6EF4AE.4030503@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 02:14:06PM +0800, Huang Ying wrote:
> Hi, Eric,
> 
> On 09/13/2011 02:11 PM, Eric Dumazet wrote:
> > Le mardi 13 septembre 2011 à 12:28 +0800, Huang Ying a écrit :
> >> Hi,
> >>
> >> If my understanding was correct, from the kernel source code, it appears
> >> that percpu_xxx and this_cpu_xxx have the same semantics and
> >> implementation in effect, haven’t them?
> >>
> >> If so, why do we need two API for the same thing?
> > 
> > History mostly, and transition.
> > 
> > percpu_inc() was an x86 only thing
> > 
> > __get_cpu_var(var)++ -> percpu_inc(var) -> this_cpu_inc(var)

Also, we used to need separate accessors for static and dynamic percpu
variables, so we have quite a few duplications in the interface.

> Thanks for clarification.  Is there someone working on the transition?
> Is that possible to translate most percpu_xxx to this_cpu_xxx blindly?

It's on my todo list but AFAIK nobody is actually working on it yet.

Thanks.

-- 
tejun
