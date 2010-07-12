Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab0GLRdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:33:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33731 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab0GLRdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:33:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kUgm1vE+R9Y+P794YgjThzBFeTegi239uU7POUR7Rmj8ZjkHvMZ4etxSu0VBbUUjbH
         zSl5Bfk0P+bsQ1TV0n7lBzYKpyyBm8Jv9SaMfBW0jkhjfIPVzAKw5pmtzdjnJ62GW5TF
         14XPzyA5zBbB96q3JfZElF0LCYrNb3cJ7JtfE=
MIME-Version: 1.0
In-Reply-To: <20100712172847.GA17423@merkur.ravnborg.org>
References: <201007120554.16459.vda.linux@googlemail.com>
	<20100712100301.db1d3980.randy.dunlap@oracle.com>
	<AANLkTin88f83UV4HcqKtaXS7F2hMTe8YVJPpE-XLmo5J@mail.gmail.com>
	<20100712172847.GA17423@merkur.ravnborg.org>
Date: Mon, 12 Jul 2010 19:33:41 +0200
Message-ID: <AANLkTimTdQRCoWzCYZ7yBLYsKr4P812n8UR678hktJbO@mail.gmail.com>
Subject: Re: Modpost error after changing CONFIG_SOUND from m to y
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 7:28 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Mon, Jul 12, 2010 at 07:11:47PM +0200, Denys Vlasenko wrote:
>> On Mon, Jul 12, 2010 at 7:03 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> > On Mon, 12 Jul 2010 05:54:16 +0200 Denys Vlasenko wrote:
>> >> I was using the same .config for my home machine for a long time,
>> >> updating it using "make oldconfig" every time I moved to newer kernel.
>> >> It worked fine for many kernels.
>> >>
>> >> In this .config I had CONFIG_SOUND=m.
>> >>
>> >> Starting witn 2.6.34, build fails with
>> >>
>> >> sound/core/sound_oss.c:25:2: error: #error "Enable the OSS soundcore multiplexer (CONFIG_SOUND) in the kernel."
>> >>
>> >> Ok. I changed CONFIG_SOUND to y. Now the build fails at modpost:
>> >
>> > Hi,
>> > I can't get the build to fail (2.6.34 or 2.6.35-rc4-git4).
>> > Please provide a full/complete .config file (and that will include a
>> > kernel version number :).
>>
>> I found out that build only fails if I give empty CFLAGS_KERNEL
>> and CFLAGS_MODULE variables to make, like this:
>>
>> make CFLAGS_KERNEL="" CFLAGS_MODULE=""
>
> Messing around with kernel internal flags is bound to give
> unpredictable bugs.
>
> I this case you loose "-DMODULE" and I guess some sound specificmodules
> test on this symbol.
> And there may be other subtle side-effects.
>
> What is the intial reason why you assign CFLAGS_KERNEL and CFLAGS_MODULE?

I want to add some flags to every compiler invocation.
-- 
vda
