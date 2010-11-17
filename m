Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab0KQAFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:05:41 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41456 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab0KQAFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:05:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=Y3hV3MK+SaBO3CAvgqY5JoYsfE4c/8Bxv9cwPVW+VhcFsF7DU7a7wCLOfWOC+xLNaF
         n0f4s0eg7/BMgLHI+VsdvatXEKGP1K+NzyhehHYO1+al2xG50f7UWsNc2geYEE/nMVkY
         oVx16MC4+J1Nki6690/moRYM6rUXkuuTRwd1c=
MIME-Version: 1.0
In-Reply-To: <1289609931.3292.87.camel@localhost.localdomain>
References: <80b5a10ac1a6ef51afca3c113b624bf1b5049452.1289427381.git.luto@mit.edu>
 <AANLkTi=s+0i36qd-bd3=MdeiJS-TThos9RmeUCsfHyy=@mail.gmail.com>
 <AANLkTimAfULHTkyLVpGv5r3DcSfVXzsgGiHgTdamNpt2@mail.gmail.com>
 <1289605221.3292.53.camel@localhost.localdomain> <AANLkTi=iso2+R6-5+2ipe39JLHw9o0TgMGCRSTqd5qQz@mail.gmail.com>
 <AANLkTikd0rstGDDcNdb8u2_H09giaZVxPY1Y5qaiy6_O@mail.gmail.com>
 <1289607722.3292.84.camel@localhost.localdomain> <1289609931.3292.87.camel@localhost.localdomain>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 16 Nov 2010 19:05:15 -0500
X-Google-Sender-Auth: Z6p-kEoOvKZzybbXOD1gdF0e-mg
Message-ID: <AANLkTim27c_pHpawoGw3VyV9qQAF_8twJPTr5kqt6jhW@mail.gmail.com>
Subject: Re: [PATCH] Improve clocksource unstable warning
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        pc@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 7:58 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Sat, 2010-11-13 at 00:22 +0000, john stultz wrote:
>> On Fri, 2010-11-12 at 18:51 -0500, Andrew Lutomirski wrote:
>> > Also wrong if cs_elapsed is just slightly less than wd_wrapping_time
>> > but the wd clocksource runs enough faster that it wrapped.
>>
>> Ok. Good point, that's a problem. Hrmmmm. Too much math for Friday. :)
>
> I have a hard time leaving things alone. :)
>
> So this still has the issue of the u64%u64 won't work on 32bit systems,
> but I think once I rework the modulo bit the following should be what
> you were describing.
>
> It is ugly, so let me know if you have a cleaner way.
>

I'm playing with this stuff now, and it looks like my (invariant,
constant, single-package i7) TSC has a max_idle_ns of just over 3
seconds.  I'm confused.

--Andy
