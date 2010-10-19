Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab0JSLM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:12:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56597 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab0JSLMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:12:55 -0400
MIME-Version: 1.0
X-Originating-IP: [196.201.218.253]
In-Reply-To: <20101019064000.GC21782@elte.hu>
References: <AANLkTinHc7tMntW5NFAhu40RC7m2=HwbqOBeE-21vL8J@mail.gmail.com>
 <20101018233834.GC5370@nowhere> <AANLkTi=Ssz4WdMDXq-93GE9bPHoaQ8QyTSrWXDSCa7eH@mail.gmail.com>
 <20101019064000.GC21782@elte.hu>
From: Brian Gitonga Marete <marete@toshnix.com>
Date: Tue, 19 Oct 2010 14:12:33 +0300
Message-ID: <AANLkTimqaTKu23HrgbffAht_Otn9L5k2oHMZDGki8MK+@mail.gmail.com>
Subject: Re: [PATCH] [PERF] (Userspace Tools) Fix a compilation error with
 -fstack-protector and -Werror
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 9:40 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Brian Gitonga Marete <marete@toshnix.com> wrote:
>
>> On Tue, Oct 19, 2010 at 2:38 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> > On Tue, Oct 19, 2010 at 02:24:00AM +0300, Brian Gitonga Marete wrote:
>> >> The following patch fixes compilation of the perf user-space tools on,
>> >> for example, gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) . It should not
>> >> break anything else.
>> >
>> >
>> >
>> > Hi,
>> >
>> > What kind of warning have you encountered and why it fixes it?
>> > Can you describe that in your changelog?
>> >
>>
>> Hello Frederic,
>>
>> Some versions of gcc, e.g. gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4), have the
>> (default) minimum size of buffers protected by `-fstack-protector' set to 8. But
>> in perf, there exist much smaller automatic buffers.
>
> Hm, it's this code:
>
>        /* newtWinChoice should really be accepting const char pointers... */
>        char yes[] = "Yes", no[] = "No";
>        return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
>
> I.e. the code is messy and GCC is right to warn about it. Hence it would be somewhat
> bad to actually remove the warning that pointed out some dodgy piece of code.
>
> Even if marking it const doesnt work due to the external libnewt API, we could at
> least put 'yes' and 'no' into file scope and mark them static?

OK. Now that I actually look closely at that fragment I can see its
useless to create the automatic arrays. Local string literals would
also work (i.e. just pass `"Yes"' and `"No"' to newtWinChoice). But
can also do what you suggested if it is anticipated that they will be
used somewhere else within the file at some other time -- Currently
they are not.

Thanks.
-- 
Brian Gitonga Marete
Toshnix Systems
Tel: +254722151590
