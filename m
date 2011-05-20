Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531Ab1ETAaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:30:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63021 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500Ab1ETAaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bUQMoF+Th09eP4s/rTSwHQHHs+qOZu17ewtI3fuXbIHM5epTQHBHLkNeYFqX/lxjql
         PaYuAYNUSBt8522Y15rGfDg0UPCbPv9XBteSNqrgkdX1aHVENLBV8C2S0jLuy36+2tOK
         U/eZdevs4cG2/0qonInAmbfSWJ+VK5Ym7h3Hk=
MIME-Version: 1.0
In-Reply-To: <6241.1305847001@neuling.org>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	<1305753895-24845-3-git-send-email-ericvh@gmail.com>
	<425.1305784718@neuling.org>
	<BANLkTimKhApFW8G1-pG0u_9Kv2YB0R1O0w@mail.gmail.com>
	<29601.1305840992@neuling.org>
	<BANLkTi=rc5vZm3xAXHpHSxSH1wBWKhv92A@mail.gmail.com>
	<6241.1305847001@neuling.org>
Date: Thu, 19 May 2011 19:30:20 -0500
Message-ID: <BANLkTindzEFRjEGkc9bLccrFUdVtvbA73A@mail.gmail.com>
Subject: Re: [PATCH 3/7] [RFC] add support for BlueGene/P FPU
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 6:16 PM, Michael Neuling <mikey@neuling.org> wrote:
> In message <BANLkTi=rc5vZm3xAXHpHSxSH1wBWKhv92A@mail.gmail.com> you wrote:
>> On Thu, May 19, 2011 at 4:36 PM, Michael Neuling <mikey@neuling.org> wrote:
>> > In message <BANLkTimKhApFW8G1-pG0u_9Kv2YB0R1O0w@mail.gmail.com> you wrote=
>> :
>> >> On Thu, May 19, 2011 at 12:58 AM, Michael Neuling <mikey@neuling.org> wr=
>> ote=3D
>> >> :
>> >> > Eric,
>> >> >
>> >> >> This patch adds save/restore register support for the BlueGene/P
>> >> >> double hummer FPU.
>> >> >
>> >> > What does this mean? =3DA0Needs more details here.
>> >> >
>>
>> okay, I've changed it a bit in [V2], if you want more I can do my best.
>
> If you can describe the whole primary and secondary registers that'd be
> cool.  ASCII art would be awesome! :-)
>

You sure you don't just want a bitfield.conf? :)  I'll do my best, but my
ASCII art isn't what it used to be.  I'll also include a reference to the PDF.

>> >
>> > Ok, sounds like there is 32*8*2 bytes of data, rather than the normal
>> > 32*8 bytes for FP only (ignoring VSX). =A0If this is the case, then you'l=
>> l
>> > need make 'fpr' in the thread struct bigger which you can do by setting
>> > TS_FPRWIDTH =3D 2 like we do for VSX.
>> >

Okay - so basically what I have now and TS_FPRWIDTH=2 ?

>>
>> Since it isn't available on other chips, shoudl it just be PPC_BGP_FPU
>> or PPC_BGP_DOUBLE_FPU?
>
> I'd probably still prefer it disassociated with the CPU name, but we are
> really bike shedding here.  I'm not too fussed.
>

I'll leave it separate and switch it to PPC_FP2 (or would you prefer
PPC_FP2_FPU to make it clear) since the public PDF refers to it this way.

If that all sounds good, I'll spin [V3] tomorrow.

     -eric
