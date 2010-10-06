Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab0JFBzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:55:38 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:53182 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab0JFBzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Kz8zSXZi09YoFwvrT/6W0xBlMj1CUyVzfGi00D5lzEI9eUjOLsttxGw75e3ltJvYTl
         36bpfogSTz+/piBUieROt8ik0DA/rDbaof/kyy/kKq8AQe7uf3l21kpjgOIwjO17QCUT
         +mJczr/FZXeZpHzqciuISodbk0ozBBME5/eRY=
MIME-Version: 1.0
In-Reply-To: <1286327715-sup-584@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	<1285916771-18033-6-git-send-email-imunsie@au1.ibm.com>
	<AANLkTins34TrEWj618_4XBRwGGFqRSehwWEp7jBubvsu@mail.gmail.com>
	<1286327715-sup-584@au1.ibm.com>
Date: Tue, 5 Oct 2010 21:55:35 -0400
Message-ID: <AANLkTimNeWEo5P0wXzszBiSYdh81=uhARA8KZPr7rcPf@mail.gmail.com>
Subject: Re: [PATCH 05/18] powerpc: Wire up 44x little endian boot for
 remaining 44x targets
From: Josh Boyer <jwboyer@gmail.com>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, paulus <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 9:28 PM, Ian Munsie <imunsie@au1.ibm.com> wrote:
> Excerpts from Josh Boyer's message of Fri Oct 01 21:27:37 +1000 2010:
>> > From: Ian Munsie <imunsie@au1.ibm.com>
>> >
>> > I haven't tested booting a little endian kernel on any of these targets,
>> > but they all claim to be 44x so my little endian trampoline should work
>> > on all of them, so wire it up on:
>> >
>> > bamboo
>> > katmai
>> > kilauea
>> > rainer
>> > sam440ep
>> > sequoia
>> > warp
>> > yosemite
>> > ebony
>>
>> I see no reason to do this at all.  If you haven't tested them and
>> there is no demand, there's no reason to wire them up.  Some might
>> actively want to disallow LE mode anyway, like the Warp or Sam440EP.
>
> I wasn't aware that the Warp and Sam440EP disallowed LE mode - I'll
> definitely unwire them and move the ARCH_SUPPORTS_LITTLE_ENDIAN to just
> the sub-arch's that support it.

Well, Warp and Sam440EP are production boards for actual companies.
The rest are all just eval boards.  I don't know if the board
maintainers care either way, I was just using them as examples of
cases where someone might.

> As for the other boards, I would like to wire them up if they are able
> to support LE mode - If anyone has one handy I would love to hear if
> they are able to begin booting a LE kernel with these patches, or when &
> how they fail.

I'd avoid anything with an FPU until that gets tested.  So no bamboo,
sequoia, canyonlands, etc.

I noticed that canyonlands isn't even covered.  I'm guessing that's
because we don't need to create a wrapper for it because U-Boot does
direct loading of vmlinux and the DTB itself.  Has anyone done any
work with getting U-Boot to work in LE mode or at least load LE
vmlinux images?  The majority of new boards are going to be using
U-Boot and it's ability to load the DTB/FDT, so that would be
something that needs addressing.

josh
