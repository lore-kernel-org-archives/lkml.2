Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab1E3A3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 20:29:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51591 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1E3A3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 20:29:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=jPoTlarGgMGbPW+vX1mvrhuh+svRkmhGaBKHF4SBFx79cKCE4fteBOtuEj3iMp4kLe
         uddEmkQniPjhvn+3hZhR7dNSBEGFKmtYl9s6tlcEmXuRkxDLAY0VfvBCLwKzkmaLGbPR
         jgyKkQ6MvFFrj7N7OJmRj3cy8Ajgm0CQAVpew=
MIME-Version: 1.0
In-Reply-To: <BANLkTim8ngH8ASTk9js-G9DxySWVb7VL3A@mail.gmail.com>
References: <BANLkTinptn4-+u+jgOr2vf2iuiVS3mmYXA@mail.gmail.com>
 <BANLkTimDtpVeLYisfon7g_=H80D0XXgkGQ@mail.gmail.com> <BANLkTim8ngH8ASTk9js-G9DxySWVb7VL3A@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 29 May 2011 20:28:46 -0400
X-Google-Sender-Auth: 3kEtenRV7EhPU0uSv8u5XHy-0FI
Message-ID: <BANLkTim67zDojKPezhyAM=rzt-Mop1SFeg@mail.gmail.com>
Subject: Re: Easy portable testcase! (Re: Kernel falls apart under light
 memory pressure (i.e. linking vmlinux))
To: Minchan Kim <minchan.kim@gmail.com>
Cc: mgorman@suse.de, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
        fengguang.wu@intel.com, andi@firstfloor.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, hannes@cmpxchg.org, riel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 2:28 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
>>
>> It works only if the zone meets high watermark. If allocation is
>> faster than reclaim(ie, it's true for slow swap device), the zone
>> would remain congested.
>> It means swapout would block.
>> As we see the OOM log, we can know that DMA32 zone can't meet high watermark.
>>
>> Does my guessing make sense?
>
> Hi Andrew.
> I got failed your scenario in my machine so could you be willing to
> test this patch for proving my above scenario?
> The patch is just revert patch of 0e093d99[do not sleep on the
> congestion queue...] for 2.6.38.6.
> I would like to test it for proving my above zone congestion scenario.
>
> I did it based on 2.6.38.6 for your easy apply so you must apply it
> cleanly on vanilla v2.6.38.6.
> And you have to add !pgdat_balanced and shrink_slab patch.

No, because my laptop just decided that it doesn't like to turn on. :(

I'll test it on my VM on Tuesday and (fingers crossed) on my repaired
laptop next weekend.

--Andy
