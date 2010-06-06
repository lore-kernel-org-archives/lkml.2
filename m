Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab0FFPrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 11:47:17 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56726 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029Ab0FFPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 11:47:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YfnBx78slx3KjrvGxzJckwJyq7y+PJKktf6R6MVlbN29H9QMLYnybq/fZNAjPB6yd6
         k0kuRudmwwKAhk9zAy+gIV7MtrDMws7PowLkndOprKb79GAM53+hyNhDMOs3sMiYRgWX
         IHcmeV8eTJEM73X+64B9WXBB4bLTWkCP+0fqA=
MIME-Version: 1.0
In-Reply-To: <20100606152946.GA11351@srcf.ucam.org>
References: <1275731653.27810.41078.camel@twins>
	<20100605092851.6ee15f13@infradead.org>
	<AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com>
	<AANLkTimKknOurmCffOpHjc1FjrP2MKf10pBwEEbLJPg_@mail.gmail.com>
	<AANLkTil1NCX91bWhpXHtC88Opr29mNjdhXD9RXQ6DI0y@mail.gmail.com>
	<AANLkTin1Za3GvfIKbcZdx6TzjIHzCvsg5uaY_Vk4nJIh@mail.gmail.com>
	<AANLkTilQ1k78dDCYadOa1Wiyjm2nsBcRpxwdpGvYcf8z@mail.gmail.com>
	<AANLkTin7oM3gVwHbIHWqYV8yeC6bbQ4q2jDDxAgz3DwQ@mail.gmail.com>
	<20100606133130.GA8513@srcf.ucam.org>
	<AANLkTimXTgZS_fZQa8hjIptJrCn756gF_xakT1IQiLWa@mail.gmail.com>
	<20100606152946.GA11351@srcf.ucam.org>
Date: Sun, 6 Jun 2010 17:47:10 +0200
Message-ID: <AANLkTilOq_5yUW1AIMH1qSE699gyRUTlzGPUVc4CrReY@mail.gmail.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
From: Vitaly Wool <vitalywool@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Brian Swetland <swetland@google.com>,
       =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/6 Matthew Garrett <mjg59@srcf.ucam.org>:
> On Sun, Jun 06, 2010 at 05:26:09PM +0200, Vitaly Wool wrote:
>> 2010/6/6 Matthew Garrett <mjg59@srcf.ucam.org>:
>> > Holding a suspend blocker is entirely orthogonal to runtime pm. The
>> > "whole kernel" will not be "active" - it can continue to hit the same
>> > low power state in the idle loop, and any runtime pm implementation in
>> > the drivers will continue to be active.
>>
>> Yeah, that might also be the case, But then again, what's the use of
>> suspend blockers in this situation?
>
> The difference between idle-based suspend and opportunistic suspend is
> that the former will continue to wake up for timers and will never be
> entered if something is using CPU, whereas the latter will be entered
> whenever no suspend blocks are held. The problem with opportunistic
> suspend is that you might make the decision to suspend simultaneusly
> with a wakeup event being received. Suspend blocks facilitate
> synchronisation between the kernel and userspace to ensure that all such
> events have been consumed and handld appropriately.

Right, and then you start taking suspend blockers in kernel here and
there which eventually interferes with runtime PM.
So I don't buy the "orthogonality" point. Generally speaking, it's not true.

~Vitaly
