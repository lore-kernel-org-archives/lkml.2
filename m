Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760873Ab0HLTeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:34:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49047 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab0HLTet convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:34:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gMV473qYoD3U26lTendXqMuSxgisF3P5O4sxXv+hP4+xgMRupgi8o/4A4qCTiGLcwT
         oiHwLSMx1/TFHrNpdNKTHTFzdZLA+unIyPsc9rfi7P5NRqFcf9sOrqzZCvxVoqbNpG6L
         6IRVse8yNzID1+2ZjrOs5GJ7uCnLeUbO9i5W0=
MIME-Version: 1.0
In-Reply-To: <20100812174303.GD2524@linux.vnet.ibm.com>
References: <20100809181638.GI3026@linux.vnet.ibm.com>
	<AANLkTikwHaKpLdRdxmZj6JDJnsZ+o-jzbVcXhRW3Jmd9@mail.gmail.com>
	<20100811222854.GJ2516@linux.vnet.ibm.com>
	<AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com>
	<20100812010612.GL2516@linux.vnet.ibm.com>
	<AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
	<20100812034435.GA7403@linux.vnet.ibm.com>
	<AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
	<E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
	<AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<20100812174303.GD2524@linux.vnet.ibm.com>
Date: Thu, 12 Aug 2010 22:34:47 +0300
Message-ID: <AANLkTim1U6QpRyfwYCq2uRA=7-a8ryfDrzv5VCqmHnyB@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 8:43 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Aug 12, 2010 at 02:11:22PM +0300, Felipe Contreras wrote:
>> So far, nobody has refuted these:
>>  1) opportunistic suspend needs a good behaved user-space to work properly
>
> As does dynamic power management.

Thus remains unrefuted.

>>  2) if suspend blockers are enabled in a system, *all* user-space must
>> implement them to work correctly
>
> Really?  From what I can see, only PM-driving applications need to use
> suspend blockers.

"PM-driving applications" is a new invention, so how do you know if an
application belongs to this category or not? Some application might be
non-PM-driving most of the time, but suddenly become PM-driving. Well,
you have to analyze *all* of them.

Think about this... is bash a PM driving application? No, but what if
you run: 'sleep 3600 && alarm.sh'.

Perhaps I should rewrite that as:
2) if suspend blockers are enabled in the system; *all* user-space is affected

>>  3) implementing suspend blockers in user-space is not a straight-forward task
>
> Fortunately, experience thus far has shown that only a small fraction of
> applications need to use suspend blockers.

Wrong. We don't have any experience on that at all on typical linux
ecosystems (remember that Android's user-space is very special).

>> So, as the length of this thread has shown, the benefits of
>> opportunistic suspend are *dubious* at best, and more likely not worth
>> the changes needed in user-space which eventually will get pretty
>> close to what suspend blockers can achieve even in ideal circumstances
>> by just doing dynamic PM.
>
> The length of this thread (and the ones preceding it) is mostly due to
> people talking past each other.

Perhaps half of the thread, or even one quarter of the thread can be
attributed to that, but still the rest I think it's because people
keep pushing in, and people keep pushing out.

> For example, the Android folks seem to
> believe that it is important that relatively unskilled people be able
> to write simple apps, and that the system nevertheless be able to run
> these apps in a relatively energy efficient manner.  Your proposals do
> not address this issue.  This might be because you are not aware of
> this desire, because you are not aware of the computing history that
> argues in favor of this requirement, or because you simply don't like
> this requirement.  Whatever the reason, until you face this requirement
> head on, either addressing it or proving that it need not be addressed,
> you will continue to be talking past the Android folks.

This "requirement" is specific to Android's user-space, isn't it?

Not Ubuntu, not Fedora, not MeeGo, not anyone with a typical
user-space seems to be having this problem. I can argue to you that
this problem can be solved in easier ways, but instead I will argue
that perhaps we should wait for somebody besides Android to complain
about it before providing a "solution". Because after all, what good
is a "solution" provided by the kernel, if the user-space is not going
to use it, ever.

-- 
Felipe Contreras
