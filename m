Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab1BPJdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 04:33:37 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53047 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758829Ab1BPJde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 04:33:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TfQrlrB2YD2RiXsCpHcw2o9V5D5t2hdUxv832adfiNgbKi+TDWCkpQSvQ/fMciT7gJ
         Ux65HpM4cVazO0lHs3TAErd7y9esyAP4SgwnowsCHn1DdtxHybjeA3lXoIBz8lhGYzbX
         yxE11tM/Yhr48n935QqQD6POacFsE/2eBjkEM=
MIME-Version: 1.0
In-Reply-To: <20110216085605.GA18842@elte.hu>
References: <4D484853.9020409@gmail.com>
	<20110202023610.3799.qmail@science.horizon.com>
	<AANLkTi=X8vCuVOCMBJiCOB-8GZRF4-5RVx59QchecLz4@mail.gmail.com>
	<AANLkTikLVMNQzmugH-ORc89_ZouX6zWvG-tHSf1QoVf3@mail.gmail.com>
	<AANLkTikx-7zJZaV2tgP=D=vZ12Brp9qrnyxLv_mVXQT3@mail.gmail.com>
	<20110216083747.GF16529@elte.hu>
	<AANLkTimXDquQV7c5yOM+1h-F08Lxti7Z5JJbbL7q7hNd@mail.gmail.com>
	<20110216085605.GA18842@elte.hu>
Date: Wed, 16 Feb 2011 12:33:32 +0300
Message-ID: <AANLkTi=JDw=BNg1ys5ifkPwY7XpapMz-1hn5bAXmYYfg@mail.gmail.com>
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@gmail.com>, George Spelvin <linux@horizon.com>,
        a.p.zijlstra@chello.nl, dzickus@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/11, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> On Wed, Feb 16, 2011 at 11:37 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> ...
>> >> >>
>> >> >
>> >> > Ping on this problem, still seeing
>> >> >
>> >> > Uhhuh. NMI received for unknown reason 3c on CPU 0.
>> >> > Do you have a strange power saving mode enabled?
>> >> > Dazed and confused, but trying to continue
>> >> >
>> >> > on my Pentium-D system here with latest Linus head.
>> >> >
>> >> > its sometimes 3c, sometimes 3d, I'm going to bisect and push for
>> >> > reverts if nobody still has any clue about how to fix this.
>> >> >
>> >> > Dave.
>> >> >
>> >>
>> >> We still trying to resolve it but without success yet. There is no
>> >> easy way to revert it. One of the option might be to disable perf on
>> >> p4 for a while. If this is acceptable -- i'll cook such patch and send
>> >> it to Ingo. Hm?
>> >
>> > That's not really acceptable - need to fix it or revert it to the last
>> > working
>> > state. Which commit broke it?
>> >
>> > Thanks,
>> >
>> >        Ingo
>> >
>>
>> I can't say you the commit id after which unknown-nmi start happening
>> (i'm out of git tree
>> at moment) but even then this commit should not be reverted since the
>> problem is in
>> p4 code not in the rest of perf system.
>>
>> I have two patches here (attached) and would really appreciate of
>> their testing on HT machine
>> together with kgdb bootup tests enabled. Dave could you please?
>
> Could these patches fix Dave's non-kgdb problem? Dave isnt using kgdb but is
> probably using perf which triggers NMIs? Dave, can you confirm that?
>
> And it's a spurious NMI message, not actual lockup or other misbehavior,
> right?
>
> Thanks,
>
> 	Ingo
>
For nonkgdb case 'unflagged nmi fix' patch should be enough. i've
tested it on non-ht machine by self. without it there is no lockup
but only a message about unknown nmi.

for hr-machine with kgdb the things go harder, Don reported lockup on
boot. The second patch might help but i cant test it (here i need help
in testing)
