Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab1ENOjG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 10:39:06 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40915 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991Ab1ENOjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 10:39:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hjU99h0Qe7yGslUCZQfxy9D4I+8V5tBNi3xjwJRQatgZeCEIlb0VFinqsDHcyfpRC+
         eUeWNk0Gu5x2xw1YDc5iljOigW4uEdgRMncikWWM2xi9tcNEvzCcPoyifLdMNrPgqYVj
         TfEpHX5Q8hT6rrHfTrIcaKB22+2vIiScxZ9mM=
MIME-Version: 1.0
In-Reply-To: <1305308919.27535.19.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1304908814-23369-1-git-send-email-daniel.blueman@gmail.com>
	<20110510073551.GH11595@elte.hu>
	<BANLkTik0GTwV0Z21+UO69JX0cqjxwqu7jw@mail.gmail.com>
	<1305071894.2736.50.camel@sbsiddha-MOBL3.sc.intel.com>
	<BANLkTimvX3YXTxVSHDFm1N9a8vsALufrMg@mail.gmail.com>
	<1305308919.27535.19.camel@sbsiddha-MOBL3.sc.intel.com>
Date: Sat, 14 May 2011 22:39:01 +0800
Message-ID: <BANLkTik3sE-z3QdHVwW5uPXDDFj=3zMyDg@mail.gmail.com>
Subject: Re: [PATCH] ioapic: fix potential resume deadlock
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suresh,

On 14 May 2011 01:48, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> On Wed, 2011-05-11 at 09:15 -0700, Daniel J Blueman wrote:
>> Superb, this works, tested against 2.6.39-rc7 and addresses the "BUG:
>> sleeping function called from invalid context at mm/slub.c:824"
>> warning I was previously seeing. It would be good to get this fix into
>> 2.6.39-final if possible.
>>
>> Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>
>
> Thanks Daniel for testing my quick patch. I have appended the complete
> patch which cleans up this code.
>
> Ingo, This patch is relatively big (mostly removes the duplicate code
> and changes the location where we allocate ioapic_saved_data, so that
> this can be shared between interrupt-remapping and io-apic
> suspend/resume flows). May be this can go into 2.6.40-rc1 and probably
> go to 2.6.39-stable?
>
> Or we can take the Daniel's GFP_ATOMIC patch for 2.6.39 and push this
> patch for 2.6.40-rc1. I am ok either way.
[]

Testing this, all looks well in that the patch resolves the
potentially sleeping allocation, however I do see (on boot) this
suspicious message (though suspend and resume does work):

IOAPIC 0: suspend/resume impossible!

I guess it's not expected...
-- 
Daniel J Blueman
