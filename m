Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab0G3PBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 11:01:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45457 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab0G3PBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 11:01:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=XRvdAnBiXm5nrwJDCp1Q+CBmuQT2CEMb2cFBaiUMHCyfdSwAePrWdF/ckbe3zYdqCR
         Sfh91Jv0xskaR8ZqFraTKQsy1rjTOcwgQRbFeYkZYh+JxBnrBvsYesRX7YOCQ5Egd8lx
         r/N1tuDrp/79Mo6UaNb9H6jzNoMlmRyez80Q8=
MIME-Version: 1.0
In-Reply-To: <AANLkTinZgu-4V8pwSZJMBw_FTHgRCMELy96ADkrBMoKt@mail.gmail.com>
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
	<1280440089-3203-2-git-send-email-john.johansen@canonical.com>
	<AANLkTikk3tNM-fsXuS_SeAWgaYYCFrFAToRXOBkPxwy9@mail.gmail.com>
	<4C52A307.7080002@canonical.com>
	<AANLkTi=mcrGTMBonxby1gR1OijPB4z072i6cNsLxNU09@mail.gmail.com>
	<AANLkTinZgu-4V8pwSZJMBw_FTHgRCMELy96ADkrBMoKt@mail.gmail.com>
Date: Fri, 30 Jul 2010 18:01:39 +0300
X-Google-Sender-Auth: NaUVaFKIy_mFD0R3WiKnUiZuhbs
Message-ID: <AANLkTimJp3fxBox7wFYxVJySKrM12mSVYYOjiXcHt_YC@mail.gmail.com>
Subject: Re: [PATCH 01/13] AppArmor: misc. base functions and defines
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Changli Gao <xiaosuo@gmail.com>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, laijs@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 5:24 PM, Changli Gao <xiaosuo@gmail.com> wrote:
> On Fri, Jul 30, 2010 at 6:53 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>> On Fri, Jul 30, 2010 at 1:01 PM, John Johansen
>>>
>>> vfree can sleep, and skipping the schedule_work parts won't work for
>>> apparmor as many of these allocations are being freed via rcu callbacks
>>> as most of our object life cycles are dependent on cred refcounting.
>>
>> Can someone point me to where vfree() actually sleeps? I'm unable to
>> find the exact spot.
>
> http://lxr.linux.no/linux+v2.6.34.1/mm/vmalloc.c#L1405 . vfree ->
> __vunmap, vunmap -> __vunmap, and there is a might_sleep() function in
> vunmap.

Yes, but that doesn't answer my question. Where's the actual call-site
that can sleep? I can't find it!

> BTW: I'll respin the kvmalloc patch later.

Great!
