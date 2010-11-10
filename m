Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0KJWv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:51:59 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:39194 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab0KJWv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:51:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=TNN5wr3PWNsR7+kLiezY0NOsCdMWFHoIFpveincRIb4Guz0sPNfARVsUbD3MslieY/
         rSw5NiHeia9HrJLMDKBYj/P1HVoP5vjl1R1RwN4PrlTUmRMtrVxcLJY76B7Q9ufGNJLQ
         nQ/7W047ucDnvMmvTZ366UZyayzzI8nvPfk7w=
MIME-Version: 1.0
In-Reply-To: <1289428526.9605.9.camel@nisroch>
References: <cover.1289423299.git.luto@mit.edu> <cb559f4c96f82d5bf0c132b3330aecd4885a0dda.1289423199.git.luto@mit.edu>
 <1289427037.9605.3.camel@nisroch> <AANLkTimfrVPaxgGXyLU-YTQBMNz_BBVMhfH+MO_CH2Cn@mail.gmail.com>
 <1289428526.9605.9.camel@nisroch>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 10 Nov 2010 17:51:35 -0500
X-Google-Sender-Auth: _oo4pA0QO1Ka2RkysuBXbaRytus
Message-ID: <AANLkTinBTnJ0OjVkcYDQmYZ_HjqE4NCSHnCvD1_p_DJs@mail.gmail.com>
Subject: Re: [PATCH 2/2] nouveau: Acknowledge HPD irq in handler, not bottom half
To: bskeggs@redhat.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 5:35 PM, Ben Skeggs <bskeggs@redhat.com> wrote:
> On Wed, 2010-11-10 at 17:25 -0500, Andrew Lutomirski wrote:
>> On Wed, Nov 10, 2010 at 5:10 PM, Ben Skeggs <bskeggs@redhat.com> wrote:
>> > On Wed, 2010-11-10 at 16:32 -0500, Andy Lutomirski wrote:
>> >> The old code generated an interrupt storm bad enough to completely
>> >> take down my system.
>> >>
>> >> This only fixes the bits that are defined nouveau_regs.h.  Newer hardware
>> >> uses another register that isn't described, and I don't have that hardware
>> >> to test.
>> > Thanks for looking at this.  I'll take a closer look at the problem
>> > today and see what I can come up with too, that'll work with the newer
>> > hardware too.
>>
>> It should be as simple as adding an hpd1 field to the hpd_state and
>> making exactly the same change.  (It would be nice to put the register
>> definitions into nouveau_regs.h as well -- I didn't really want to
>> muck around with a bunch of magic numbers that I can't test.)
> Yes, it is.  I can confirm the problem on another card, but it doesn't
> actually cause any crashes here.  If you can rework the patch to support
> the newer chips too, that'd be great.
>
> As for magic numbers, the register names for those regs are wrong
> anyway.  The joy of reverse-engineering the support.  It doesn't really
> matter if you want to stick to them or go back to "magic" numbers.

That explains why INTR and CTRL seemed backwards :)  I'll leave the
magic numbers for the 0xe07? stuff.

Also, I accidentally dropped the "& enabled_bits" part -- I'll put that back.

Patch to follow after I boot and test it here.

--Andy
