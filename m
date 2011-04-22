Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab1DVInk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 04:43:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33947 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab1DVInj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B1GOvuMiZi1hRuq12TJZHHUqMvlo60kTEoPZGJicVboQ6Aj3k9Mc5Mu51aPAeOVfgb
         nRyIP0Qibfo2VZrg+b7bHvN/lR+BWu+J/Q25wR6PpnyGBgoev3uaOt3Z0Q/E9u1lz1UZ
         alP93BCKOQpIhqm/Ix6mPugagi3yaSvdvY400=
MIME-Version: 1.0
In-Reply-To: <20110422081838.GA24011@elte.hu>
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
	<1303398203-2918-5-git-send-email-dzickus@redhat.com>
	<20110422081838.GA24011@elte.hu>
Date: Fri, 22 Apr 2011 12:43:38 +0400
Message-ID: <BANLkTimh80LorfC8O-HOPAAWK9BLYNjcXA@mail.gmail.com>
Subject: Re: [PATCH 4/4] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

P4 cant move events between counters in compare with architectural
event so when nmi-watchdog is used perf top is blocked because it
needs same counters but the counters already borrowed for watchdog. as
result we need a different event and counters for watchdog.

Ingo, nonsleeping cycles is from intel sdm, so when someone start
reading this code in future will find this term in sdm fast. or i
could put the reference from sdm itself here, hm?

On Friday, April 22, 2011, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Don Zickus <dzickus@redhat.com> wrote:
>
>> From: Cyrill Gorcunov <gorcunov@gmail.com>
>>
>> Due to restriction and specifics of Netburst PMU we need
>> a separated event for NMI watchdog. Note that on all other
>> than P4 PMU cpus this event is a simple alias for PERF_COUNT_HW_CPU_CYCLES.
>>
>> This event is only used by x86 for now so no other archs involved.
>
> hm, there's no explanation exactly why this is needed and what the alternatives
> are.
>
> This sentence:
>
>> +  /* we use that named non-sleeping calls */
>
> does not parse for me.
>
> Thanks,
>
>         Ingo
>
