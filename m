Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab0DHJk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 05:40:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36766 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab0DHJkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 05:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZxpecjnldLTvuWDgK6Gp+cATwivCwhdBupHiewLzBhas3Pgf/V2Yg3oOx3d1ob4m6r
         8j5JQ+3dullA4oI3SJepK4BcqBVQDEIl1iw0T/90aISTn6GoEyRbDqtjyUsnBMjSX8Wi
         KO2BsvCy/XrTZvMuV7zrGskeqIwZ3X63C8k6s=
MIME-Version: 1.0
In-Reply-To: <4BBD42BE.20307@kernel.org>
References: <1268989324-7575-1-git-send-email-graff.yang@gmail.com>
	 <4BA449E2.3080707@kernel.org>
	 <7d86d44a1003211933h6628ae04vc9d1c393e1733ce5@mail.gmail.com>
	 <4BB47367.8030305@kernel.org>
	 <y2l4e5ebad51004060228t814129beqd0d90059e247e48d@mail.gmail.com>
	 <4BBD42BE.20307@kernel.org>
Date: Thu, 8 Apr 2010 17:40:24 +0800
Message-ID: <x2p4e5ebad51004080240nc3f5846am27fa259debf04302@mail.gmail.com>
Subject: Re: [PATCH] mm/nommu.c:Dynamic alloc/free percpu area for nommu
From: Sonic Zhang <sonic.adi@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: graff yang <graff.yang@gmail.com>, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 10:43 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Sonic.
>
>> I tested your patch on NOMMU bf561 with SMP enabled. It is compiled
>> and boots without problem. Because there are few percpu data defined
>> in bf561 SMP kernel, the functions in mm/percpu-km.c may not be
>> executed with a simple test. But, since these functions are simple
>> malloc/free, I don't see any problem.
>
> Great, thanks for testing.  Just in case, can you please test with the
> attached module?  In test-pcpu.c, the cmds table directs the module
> what to allocate and free.  { size > 0, tag } entry makes it allocate
> an area with the specified size and tag and { 0, tag } entry makes it
> free all areas with the matching tag.  The existing table makes pretty
> large amount of allocations and might not work very well on nommu
> configuration.  There are also several DEFINE_PER_CPU() instances to
> test module static percpu area alloc/free.  Please insmod/rmmod in
> loop and make sure it doesn't leak any memory or crashes the machine.
>

Tejun,

There is memory leak with you patch. Free memory continuously
decreases when running test_pcpu. After about 30 minutes, kernel hangs
in out_of_memory().


root/> while [ 1 ]; do modprobe test_pcpu; rmmod test_pcpu; cat
proc/meminfo; done


Sonic

> Thanks.
>
> --
> tejun
>
