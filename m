Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab0JSCwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 22:52:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47317 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab0JSCws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 22:52:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fPpNKVJQRDt+/quikq2SwEXLV3AG2D7g4aiP6RDDrWHA5mA1alaGlQY+cOzDJhyh3M
         ghRmuZqvtHuvuKwD3MSwIz6aycueSFwPthWhbMrGy27PUkJuUZL+oDGZjGWQUR/nY28E
         kXdHGPlNMIsUVVT9riZbghGmX2xQcdCOXL3OU=
MIME-Version: 1.0
In-Reply-To: <20101019023537.GB8310@localhost>
References: <20101019093142.509d6947@notabene>
	<20101018154137.90f5325f.akpm@linux-foundation.org>
	<20101019095144.A1B0.A69D9226@jp.fujitsu.com>
	<AANLkTin38qJ-U3B7XwMh-3aR9zRs21LgR1yHfqYifxrn@mail.gmail.com>
	<20101019023537.GB8310@localhost>
Date: Tue, 19 Oct 2010 11:52:47 +0900
Message-ID: <AANLkTikHxDyjOGgM8-X6FNT15Hr3s4NaA-=+FRhma+3D@mail.gmail.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wu,

On Tue, Oct 19, 2010 at 11:35 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> @@ -2054,10 +2069,11 @@ rebalance:
>>                 goto got_pg;
>>
>>         /*
>> -        * If we failed to make any progress reclaiming, then we are
>> -        * running out of options and have to consider going OOM
>> +        * If we failed to make any progress reclaiming and there aren't
>> +        * many parallel reclaiming, then we are unning out of options and
>> +        * have to consider going OOM
>>          */
>> -       if (!did_some_progress) {
>> +       if (!did_some_progress && !too_many_isolated_zone(preferred_zone)) {
>>                 if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
>>                         if (oom_killer_disabled)
>>                                 goto nopage;
>
> This is simply wrong.
>
> It disabled this block for 99% system because there won't be enough
> tasks to make (!too_many_isolated_zone == true). As a result the LRU
> will be scanned like mad and no task get OOMed when it should be.

If !too_many_isolated_zone is false, it means there are already many
direct reclaiming tasks.
So they could exit reclaim path and !too_many_isolated_zone will be true.
What am I missing now?


> Thanks,
> Fengguang
>



-- 
Kind regards,
Minchan Kim
