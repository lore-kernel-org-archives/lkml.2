Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0JGQZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 12:25:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42387 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab0JGQZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 12:25:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VtXqCMZ/1SMVcfVXHADVzVEEjTCP5muANdSLkFw8Lbf1afu/2nEeqLFGXMkqll6EF6
         xbKKdrVxeM/VmrLvCnGZLuuc5AAKwNmPB5ltnuRxL52/kFpK96p6PkiuSIxlRDZ+vg4a
         YQkQDPMAS/yPYdkC5opuAz+ZHD835bMQgHXoI=
MIME-Version: 1.0
In-Reply-To: <20101001220343.GA10494@lixom.net>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	<2C5357FA-F87F-457E-B5C1-0DCC5A842DE7@kernel.crashing.org>
	<AANLkTinSDMvBb7rnnfwYMkEVOgDUqRetZg86rh-UmSAg@mail.gmail.com>
	<1285935283.2463.78.camel@pasglop>
	<BBD78246-343E-4A96-9E55-3E40AD628C0B@kernel.crashing.org>
	<1285966315.2463.141.camel@pasglop>
	<20101001220343.GA10494@lixom.net>
Date: Thu, 7 Oct 2010 09:25:27 -0700
X-Google-Sender-Auth: fPYAhDoYBC-xbPr-DiuL5Dlz-4k
Message-ID: <AANLkTim0+SU3EqRe6x5aXR+G-Gczv6gBSrrdinXQavSa@mail.gmail.com>
Subject: Re: Introduce support for little endian PowerPC
From: Hollis Blanchard <hollis@penguinppc.org>
To: Olof Johansson <olof@lixom.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Ian Munsie <imunsie@au1.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 3:03 PM, Olof Johansson <olof@lixom.net> wrote:
> On Sat, Oct 02, 2010 at 06:51:55AM +1000, Benjamin Herrenschmidt wrote:
>> On Fri, 2010-10-01 at 12:59 -0500, Kumar Gala wrote:
>> > I'm not against it, and I agree some of the patches seem like good
>> > clean up.  I'm concerned about this bit rotting pretty quickly.
>>
>> Maybe. Most of it doesn't seem to be that bit-rottable.
>>
>> The changes to the asm stuff in misc_32.S for example are functions we
>> never ever touch once written (libgcc replacements) so I don't see them
>> rotting more with LE support than they did with BE :-)
>
> Does KVM/qemu support running LE guest on BE host? That'd help keeping
> the bitrot lower. :)

Surprisingly, qemu has very poor support for the concept of
endianness. The fact that BE PowerPC works on both BE and LE hosts in
Qemu today is more accidental than anything else (the special curse of
endianness is that two wrongs make a right). Supporting LE PowerPC
guests would be a dramatic effort, and I'm pretty sure it would impact
other qemu architectures as well.

-Hollis
