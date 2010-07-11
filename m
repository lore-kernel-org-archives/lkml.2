Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab0GKLye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 07:54:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34459 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab0GKLyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 07:54:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=acpxGrctY0OUFd9qqj/yD2e+KGsHzTv8bSUlA54lvoq906kaaoytN9V6CBhD6KLTax
         EC+Ignp6MatQLJbMRGG6ghDGLEPKXTVTz9ds0t2QppXqxSJY/U7VqSgShPbObJPTVPqX
         3aHDMWIMI+M67oCDs0Tas8f1x4Y3oWTg8xZXQ=
MIME-Version: 1.0
In-Reply-To: <20100710154331.GF10080@8bytes.org>
References: <AANLkTilPtW_hOG01qvQHBWMC4b0QJZ8SAL0bZi6j56ns@mail.gmail.com>
	<AANLkTilQ0w6EfbrXl5LklPJ46FMWQG6Q3W5twJY74RtE@mail.gmail.com>
	<AANLkTinLjhLoQJ8URiuCKqgntiLEKxCesNEPZ8b24uLu@mail.gmail.com>
	<20100710154331.GF10080@8bytes.org>
Date: Sun, 11 Jul 2010 12:54:31 +0100
Message-ID: <AANLkTin24TP3qcCb4c0-dLfqysyBDYSrPiO3UXtp-Y1n@mail.gmail.com>
Subject: Re: [2.6.35-rc3] select useful number of entries for DMA debugging...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2010 16:43, Joerg Roedel <joro@8bytes.org> wrote:
> On Sat, Jul 10, 2010 at 03:52:04PM +0100, Daniel J Blueman wrote:
>> On 9 July 2010 22:33, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> > On Mon, Jul 5, 2010 at 1:35 AM, Daniel J Blueman
>> > <daniel.blueman@gmail.com> wrote:
>> >> When booting 2.6.35-rc3 on some different x86 boxes with DMA debugging
>> >> enabled, I've consistently seen it exhaust the allocated entries during
>> >> boot, giving 'DMA-API: debugging out of memory - disabling'.
>> >>
>> >> Increase number of entries to allow DMA debugging again.
>> >
>> > Rather than increase the default that gets allocated whenever anybody
>> > enables the DMA debugging, I'd really prefer to see people use the
>> > kernel command line option if they run out. After all, it's a (pretty
>> > esoteric) debug option, and the number of required entries depends on
>> > machine configuration. I'd rather not make the default cover a huge
>> > number, when you could just add
>> >
>> >   dma_debug_entries=65536
>> >
>> > on the kernel boot command line instead for machines that want/need it..
>>
>> That said, I am seeing the DMA pool exhaust on a single socket Core i5
>> system with Intel graphics and no other adapters - seems like a fairly
>> common case. If eg 25% of developers will be using similar to this,
>> maybe it's good to make DMA debugging less immediately esoteric?
>>
>> On the other hand, I would immediately agree if the exhaustion
>> occurred on an atypical setup.
>
> How much memory do you have in this machine? We could probably make the
> number of pre-allocated entries dependent on the memory available in the
> machine like Ingo suggested some time ago to avoid such problems.

I have 4GB. Since this change is specific to x86, I guess the only
corner case we need to protect from this change is developers on small
x86 embedded systems such as MIDs, so lowering the allocated size on
<1GB systems makes sense.
-- 
Daniel J Blueman
