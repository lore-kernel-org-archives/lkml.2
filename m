Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0HZXwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:52:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65133 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab0HZXw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:52:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=M+8rKuF5pzybfA2WwWKoY40FPecpaDvppM2F3cBjw+ntPXUxQFEq1LBKEjtwHsA7FD
         KJwDYrwgr4mU9ZtPehwSyy95N114wv0tIjHsTuoUn9LqskUNsYAmpwWc53BlMwYqwXjB
         Lx1NsdaV28S507p2ABqYx69e9XyspVf2AxNRE=
MIME-Version: 1.0
In-Reply-To: <AANLkTim75Z-X--LDJX8MLYF8G=vPW_GniVFQrkL7QoAy@mail.gmail.com>
References: <AANLkTimT4T-6dO=Uo05DexYf3exq=0SkZemHuB5aRP3Q@mail.gmail.com>
	<AANLkTim75Z-X--LDJX8MLYF8G=vPW_GniVFQrkL7QoAy@mail.gmail.com>
Date: Thu, 26 Aug 2010 16:52:27 -0700
Message-ID: <AANLkTikg7Q_oOecNgVLPPTu3dOu3aO776f4y1bw410PV@mail.gmail.com>
Subject: Re: divide by zero bug in find_busiest_group
From: Chetan Ahuja <chetan.ahuja@gmail.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 12:19 PM, Venkatesh Pallipadi <venki@google.com> wrote:
> On Wed, Aug 25, 2010 at 6:17 PM, Chetan Ahuja <chetan.ahuja@gmail.com> wrote:

> I tried reproducing the problem with vanilla kernel and couldn't
> reproduce it. May be your workload is triggering this some how?
> Also, Suresh did recent fixes to rt_avg and this may not be a problem
> after that. I Haven't looked at this case closely after that recent
> change.
>
> Thanks,
> Venki
>

Venkatesh,

     Thanks for your detailed response. I admit complete ignorance of
the actual logic of the complicated cpu_power computations (or indeed,
any other part of the scheduler code). I'm just looking at it from the
perspective of bug-hunting in an unfamiliar piece of code. I think the
three ways we've so far identified the cpu_power can be zero so far
(all three would be extremely low probability events admittedly) are
warning signs that the code is trying to do  a bit too much. It seems
to be rather difficult to prove  correctness of the math or the
synchronization for my taste. Is there a clear and present use-case
which driving all these complicated computations ?

 For one thing, I don't understand the reason for recomputing
cpu_power dynamically. How does cpu_power of a gorup (which I believe
refers to the group of "hyper-threaded" cores on one physical core)
change while inthe system is in operation ? Is this in support of
hot-swappable CPU's or something ?

  To be honest, for my use case, I'd  like to just disable the whole
work-stealing stuff (referred to as load-balancing in the kernel).
There seems to be no config option that isolates just the dynamic
load-balancing parts (or is there ?) so maybe I'd just hack away the
load-balancing functions by hand so as never to worry about those
denominators again.

Chetan
