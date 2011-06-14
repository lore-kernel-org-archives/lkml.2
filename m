Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1FNMdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:33:10 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:58342 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1FNMdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=OvCHHczVoZ9TMEPanp65b4MSMVvj6gkIJ2vAv1ghw84xtILr++423AmWeBQ5Rm83/N
         VTQQbgDY8mnYj47HBXuIsogBp1rW78icnGQvDhLjyg/cTANEash2IJcJ+c5Y0j662Ptl
         U4B6IazpNXEYLWefUdJBkr/y50jaNCrA6hHr4=
MIME-Version: 1.0
In-Reply-To: <20110614101047.GG6371@cmpxchg.org>
References: <BANLkTinptn4-+u+jgOr2vf2iuiVS3mmYXA@mail.gmail.com>
 <BANLkTimDtpVeLYisfon7g_=H80D0XXgkGQ@mail.gmail.com> <BANLkTim8ngH8ASTk9js-G9DxySWVb7VL3A@mail.gmail.com>
 <BANLkTim67zDojKPezhyAM=rzt-Mop1SFeg@mail.gmail.com> <20110614101047.GG6371@cmpxchg.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 14 Jun 2011 08:32:48 -0400
X-Google-Sender-Auth: xzUyo8Pw2hxsAgMfl8Gh23r15Kk
Message-ID: <BANLkTimJVvGaEZBm1+tRvkNYoCv4p0rk7Q@mail.gmail.com>
Subject: Re: Easy portable testcase! (Re: Kernel falls apart under light
 memory pressure (i.e. linking vmlinux))
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan.kim@gmail.com>, mgorman@suse.de,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, aarcange@redhat.com,
        kamezawa.hiroyu@jp.fujitsu.com, fengguang.wu@intel.com,
        andi@firstfloor.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        riel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 6:10 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Sun, May 29, 2011 at 08:28:46PM -0400, Andrew Lutomirski wrote:
>> On Sun, May 29, 2011 at 2:28 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
>> >>
>> >> It works only if the zone meets high watermark. If allocation is
>> >> faster than reclaim(ie, it's true for slow swap device), the zone
>> >> would remain congested.
>> >> It means swapout would block.
>> >> As we see the OOM log, we can know that DMA32 zone can't meet high watermark.
>> >>
>> >> Does my guessing make sense?
>> >
>> > Hi Andrew.
>> > I got failed your scenario in my machine so could you be willing to
>> > test this patch for proving my above scenario?
>> > The patch is just revert patch of 0e093d99[do not sleep on the
>> > congestion queue...] for 2.6.38.6.
>> > I would like to test it for proving my above zone congestion scenario.
>> >
>> > I did it based on 2.6.38.6 for your easy apply so you must apply it
>> > cleanly on vanilla v2.6.38.6.
>> > And you have to add !pgdat_balanced and shrink_slab patch.
>>
>> No, because my laptop just decided that it doesn't like to turn on. :(
>>
>> I'll test it on my VM on Tuesday and (fingers crossed) on my repaired
>> laptop next weekend.
>
> Any updates on this?
>

Sorry, got distracted by writing my thesis.

This patch (Revert "writeback: do not sleep on the congestion queue if
there are no congested BDIs or if significant congestion is not being
encountered in the current zone") does not fix the problem; if
anything it triggers more easily with the patch (at least in KVM).

--Andy
