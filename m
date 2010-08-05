Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab0HEMdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:33:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46562 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239Ab0HEMdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hCrQ64be9R4lCAv/4GOOjbPnc9zqPUr2ZkrniTdq8nk7KCmTx9pSmlJge05BSfSgfo
         hD+khMder60jsWRFrbEFqKKEsQ8/q65URoG1eRNaChn3ozvx4J1PX3DenRDNx3TYEQtR
         YW/Q8DDzm2jzjMZJr7X92JtWqqhkiR+uPLcaA=
MIME-Version: 1.0
In-Reply-To: <1280937526.28884.21.camel@work-vm>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
	<1280937526.28884.21.camel@work-vm>
Date: Thu, 5 Aug 2010 15:33:14 +0300
X-Google-Sender-Auth: bJNoScyhw0OFjzdF1zzWkhsMbE4
Message-ID: <AANLkTin_5RVQo8qbJp=naN6WHdA39JM81Y+003E0SLOq@mail.gmail.com>
Subject: Re: [PATCH] [RFC] notify userspace about time changes
From: Alexander Shishkin <virtuoso@slind.org>
To: john stultz <johnstul@us.ibm.com>
Cc: gregkh@suse.de, lkml@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 August 2010 18:58, john stultz <johnstul@us.ibm.com> wrote:
> On Wed, 2010-08-04 at 15:48 +0300, Alexander Shishkin wrote:
>> Certain userspace applications (like "clock" desktop applets or ntpd) might
>> want to be notified when some other application changes the system time. It
>> might also be important for an application to be able to distinguish between
>> its own and somebody else's time changes.
>
> So NTP doesn't actually care, as it will notice the STA_UNSYNC flag is
> set the next time it checks adjtimex.
>
> The clock apps example seems reasonable, but maybe isn't the most
> compelling argument for adding a new kernel api.
>
> Is there a actual use case that you need this for?  I don't really have
> an issue with the code I just really want to make sure the feature would
> be useful enough to justify the API and code maintenance going forward.

Yes. What we have here is an application which takes care of different means
of time synchronization (trusted time servers, different GSM operators, etc)
and also different kinds of time-based events/notifications (like "dentist
appointment next thursday"). When it encounters a time change that is
made by some other application, it basically wants to disable automatic
time adjustment and trigger the events/notifications which are due at this
(new) time.

Regards,
--
Alex
