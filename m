Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab0KJWzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:55:32 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46349 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab0KJWzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:55:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C192dyJohMPZRjxkvBEGU2vmKnfuMAbebzc9ZiEwwg401EZI4CKt8DS4SrsEuz70/d
         xiBiuWXz0QMlPdQ7iOiQKf8LMwH18EVUARW73Y6/uEWtiDRuQWo2fUqJtbZWTdouluN7
         jp+so5v5IkYTWDOe9I+WwBaL09Ybt/0KBHs2I=
MIME-Version: 1.0
In-Reply-To: <AANLkTinBTnJ0OjVkcYDQmYZ_HjqE4NCSHnCvD1_p_DJs@mail.gmail.com>
References: <cover.1289423299.git.luto@mit.edu>
	<cb559f4c96f82d5bf0c132b3330aecd4885a0dda.1289423199.git.luto@mit.edu>
	<1289427037.9605.3.camel@nisroch>
	<AANLkTimfrVPaxgGXyLU-YTQBMNz_BBVMhfH+MO_CH2Cn@mail.gmail.com>
	<1289428526.9605.9.camel@nisroch>
	<AANLkTinBTnJ0OjVkcYDQmYZ_HjqE4NCSHnCvD1_p_DJs@mail.gmail.com>
Date: Wed, 10 Nov 2010 23:55:30 +0100
Message-ID: <AANLkTi=bQtqj2D2UWxZiQ0k-oZU4g5JXrsq4tmn9=ZNZ@mail.gmail.com>
Subject: Re: [PATCH 2/2] nouveau: Acknowledge HPD irq in handler, not bottom half
From: Maarten Maathuis <madman2003@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: bskeggs@redhat.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 11:51 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Wed, Nov 10, 2010 at 5:35 PM, Ben Skeggs <bskeggs@redhat.com> wrote:
>> On Wed, 2010-11-10 at 17:25 -0500, Andrew Lutomirski wrote:
>>> On Wed, Nov 10, 2010 at 5:10 PM, Ben Skeggs <bskeggs@redhat.com> wrote:
>>> > On Wed, 2010-11-10 at 16:32 -0500, Andy Lutomirski wrote:
>>> >> The old code generated an interrupt storm bad enough to completely
>>> >> take down my system.
>>> >>
>>> >> This only fixes the bits that are defined nouveau_regs.h.  Newer hardware
>>> >> uses another register that isn't described, and I don't have that hardware
>>> >> to test.
>>> > Thanks for looking at this.  I'll take a closer look at the problem
>>> > today and see what I can come up with too, that'll work with the newer
>>> > hardware too.
>>>
>>> It should be as simple as adding an hpd1 field to the hpd_state and
>>> making exactly the same change.  (It would be nice to put the register
>>> definitions into nouveau_regs.h as well -- I didn't really want to
>>> muck around with a bunch of magic numbers that I can't test.)
>> Yes, it is.  I can confirm the problem on another card, but it doesn't
>> actually cause any crashes here.  If you can rework the patch to support
>> the newer chips too, that'd be great.
>>
>> As for magic numbers, the register names for those regs are wrong
>> anyway.  The joy of reverse-engineering the support.  It doesn't really
>> matter if you want to stick to them or go back to "magic" numbers.
>
> That explains why INTR and CTRL seemed backwards :)  I'll leave the
> magic numbers for the 0xe07? stuff.

Perhaps remove the bad definitions from the reg file, or rename them
to UNKsomething?

>
> Also, I accidentally dropped the "& enabled_bits" part -- I'll put that back.
>
> Patch to follow after I boot and test it here.
>
> --Andy
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>



-- 
Far away from the primal instinct, the song seems to fade away, the
river get wider between your thoughts and the things we do and say.
