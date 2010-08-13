Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934543Ab0HMPkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 11:40:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65232 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab0HMPka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 11:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Naa5lFSEyDn4tsWHW9qh7vqYsAv0PNQaRkGlq/GCA5J33/cq/AKPKfgR5OSx6JokXL
         02e7A9Z6aYsvL7QDJ02KGTtAOUamsRjzKxUzZO2bq+70hBfHGWcqVlicf3HSOWe9Mh+8
         Y6i5pIW8bwcHC8yfee7Pkg2DeEUmYIzd2u6n4=
MIME-Version: 1.0
In-Reply-To: <20100813152254.GD2511@linux.vnet.ibm.com>
References: <20100811222854.GJ2516@linux.vnet.ibm.com>
	<AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com>
	<20100812010612.GL2516@linux.vnet.ibm.com>
	<AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
	<20100812034435.GA7403@linux.vnet.ibm.com>
	<AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
	<E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
	<AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<20100812174303.GD2524@linux.vnet.ibm.com>
	<AANLkTim1U6QpRyfwYCq2uRA=7-a8ryfDrzv5VCqmHnyB@mail.gmail.com>
	<20100813152254.GD2511@linux.vnet.ibm.com>
Date: Fri, 13 Aug 2010 18:40:28 +0300
Message-ID: <AANLkTimdpgC2DBn1pS2OG35+_06-L6TZ9Q_nb+C6Yeqv@mail.gmail.com>
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

On Fri, Aug 13, 2010 at 6:22 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Aug 12, 2010 at 10:34:47PM +0300, Felipe Contreras wrote:
>> "PM-driving applications" is a new invention, so how do you know if an
>> application belongs to this category or not? Some application might be
>> non-PM-driving most of the time, but suddenly become PM-driving. Well,
>> you have to analyze *all* of them.
>
> A PM-driving application is one that exerts control over the system's
> power state.  In the case of Android, a PM-driving application is one
> that is permitted to acquire suspend blockers.

I already mentioned that a "PM-driving application" might not have
suspend-blockers; because the user denied them, or because the
developer forgot them.

>> Think about this... is bash a PM driving application? No, but what if
>> you run: 'sleep 3600 && alarm.sh'.
>
> That is an excellent example, as it applies equally to dynamic power
> management.  By how much are you allowed to delay the wakeup?

Huh? Certainly not days, which if Android guys are right, might be how
much the task will be delayed.

>> Perhaps I should rewrite that as:
>> 2) if suspend blockers are enabled in the system; *all* user-space is affected
>
> That is speculation on your part.

Not really. Say you have 100 packages in your system, how do you know
which ones would be PM-driving? Can you grep for something, or see if
they open certain file? No, you have to analyze them one by one; they
*all* are affected, although not all might require modifications.

But assuming I'm wrong, that's precisely the reason why a practical
exercise would help.

>> This "requirement" is specific to Android's user-space, isn't it?
>
> That is your speculation.

Which is why we need something practical.

>> Not Ubuntu, not Fedora, not MeeGo, not anyone with a typical
>> user-space seems to be having this problem. I can argue to you that
>> this problem can be solved in easier ways, but instead I will argue
>> that perhaps we should wait for somebody besides Android to complain
>> about it before providing a "solution". Because after all, what good
>> is a "solution" provided by the kernel, if the user-space is not going
>> to use it, ever.
>
> At this point in the discussion, I am quite prepared to believe that you
> will avoid using suspend blockers, and that you will further do everything
> in your power to prevent anyone else from using suspend blockers.  ;-)

I'm not tying anybody's hands.

How are people using real-time linux if it's not on mainline? Well,
duuh, you apply the patches. If say Fedora was interested on it, they
could apply the patches, and see for themselves. People do that all
the time, with the mm tree, with Con Koliva's patches, etc. Once
people are happy with the results, things get merged. Why should this
be any different?

-- 
Felipe Contreras
