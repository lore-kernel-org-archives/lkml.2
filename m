Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1FHPWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 11:22:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60181 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab1FHPWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 11:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=kY1chVfS8XSHzOke/6eH3EkHJgziBpFsn7lL/eN2OFX9yJ/QFBo7PzYOTZrWDrdMCE
         syFpubud+KtH60X1R+dBjU/Rq0HBYAjKzFHNxdSEmY6kxG/ZujegiGslJcjjtyzV2bZu
         AgKJkyP5YqKOfnNWH263JVKbRYtl3FMSOOIcM=
MIME-Version: 1.0
In-Reply-To: <BANLkTinL60RXZNH1QW9NdrTv10TckgWFcg@mail.gmail.com>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
 <1307373819.3098.40.camel@edumazet-laptop> <1307376672.2322.167.camel@twins>
 <1307376989.2322.171.camel@twins> <1307377349.3098.65.camel@edumazet-laptop>
 <1307377782.2322.183.camel@twins> <1307378564.3098.67.camel@edumazet-laptop>
 <4DED1421.5000300@linux.intel.com> <1307383898.3098.90.camel@edumazet-laptop>
 <4DED976C.90009@linux.intel.com> <4DEE3944.5020005@mit.edu>
 <1307462300.3091.39.camel@edumazet-laptop> <BANLkTinyuHUGXACJYUT241g8rzg6AzPBiA@mail.gmail.com>
 <BANLkTinHEyRnnJqB=GTwBOAb6aRaHnjQLQ@mail.gmail.com> <BANLkTi=uQmePFOJUx=bdTsnFuFa+ZaYqVw@mail.gmail.com>
 <BANLkTi=vwJBgkKSY_Cq_jQS-71gH6uOPaw@mail.gmail.com> <BANLkTinL60RXZNH1QW9NdrTv10TckgWFcg@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 8 Jun 2011 11:21:58 -0400
X-Google-Sender-Auth: dhCCz866vbSHfl41lECjaasi2w8
Message-ID: <BANLkTin-_0CgcykGiQq81fmH_ipa0WNtKA@mail.gmail.com>
Subject: Re: Change in functionality of futex() system call.
To: David Oliver <david@rgmadvisors.com>
Cc: Kyle Moffett <kyle@moffetthome.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 11:20 AM, David Oliver <david@rgmadvisors.com> wrote:
>
> Having a new call is inelegant from a futex(2) user perspective, as
> the need for a change is due to the kernel implementation and/or mutex
> requirements. The futex() system call, as documented, is ideal for a
> single producer to signal multiple receivers of state updates.
>
> If it is truly necessary to add new variants to futex() to protect
> applications that allow untrusted applications read access to their
> mutexes, I would avoid both the names suggested, as consumption of
> wakeups is not an obvious issue to users, and POLL suggests waiting
> for multiple entities as in poll(2) (which is not provided), or
> returning immediately (which is orthogonally provided by the timeout
> parameter). What is being provided from the user point of view is a
> FUTEX_WAIT per the man page, which doesn't require write access. How
> about FUTEX_WAIT_RDONLY?

That name sounds good.

>
> Alternatively, use the current call and document that when process
> performing a FUTEX_WAIT on read-only memory are woken, they do not
> count towards the number reported as being woken.

I don't see anything wrong with that, either.

>
> Best, IMHO, would be to document that providing read access to mutexes
> to untrusted software is unsafe behavior, and restore read only access
> to readers of futexes.

I think it should be safe, and it would be easy to make it be safe
(i.e. make no changes at all).

--Andy
