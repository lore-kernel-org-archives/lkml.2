Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab0G3OY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 10:24:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56586 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab0G3OY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 10:24:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=r4R5fEE2Ii+RwJHH7lg1K5XvmfaA2Ofq4PrncMTvo2jurAjZeruTP0hy12dV8JQox2
         /+EuZiwpEfZr/QEO5vdWE151uwh+C4sQyY5pQqW/47BQSawcgno6qr6hhYreNWnIp6mR
         dw9nHuA3D0YUeJAk6o363NNsctuPqlKl0hBp8=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=mcrGTMBonxby1gR1OijPB4z072i6cNsLxNU09@mail.gmail.com>
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com> 
	<1280440089-3203-2-git-send-email-john.johansen@canonical.com> 
	<AANLkTikk3tNM-fsXuS_SeAWgaYYCFrFAToRXOBkPxwy9@mail.gmail.com> 
	<4C52A307.7080002@canonical.com> <AANLkTi=mcrGTMBonxby1gR1OijPB4z072i6cNsLxNU09@mail.gmail.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 30 Jul 2010 22:24:06 +0800
Message-ID: <AANLkTinZgu-4V8pwSZJMBw_FTHgRCMELy96ADkrBMoKt@mail.gmail.com>
Subject: Re: [PATCH 01/13] AppArmor: misc. base functions and defines
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, laijs@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 6:53 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Fri, Jul 30, 2010 at 1:01 PM, John Johansen
>>
>> vfree can sleep, and skipping the schedule_work parts won't work for
>> apparmor as many of these allocations are being freed via rcu callbacks
>> as most of our object life cycles are dependent on cred refcounting.
>
> Can someone point me to where vfree() actually sleeps? I'm unable to
> find the exact spot.
>

http://lxr.linux.no/linux+v2.6.34.1/mm/vmalloc.c#L1405 . vfree ->
__vunmap, vunmap -> __vunmap, and there is a might_sleep() function in
vunmap.

BTW: I'll respin the kvmalloc patch later.

Thanks.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
