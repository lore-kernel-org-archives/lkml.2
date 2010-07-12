Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab0GLRkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:40:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37854 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab0GLRkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xkxA0uOU3aFIKhBp8/kybz9vzWHwVgy3f5XV/Rdf+iAg3GowfsxlACR6+c5nedNUHv
         SdVUUiZwcygii8UvXYccwC1ZjMZDDuExNNZjs103anX7B9FVwjX113FvdU3u7vHL8rrI
         mHLhVmK3aGmKNOddmXglFyZK2cbrITYZ/y6GQ=
MIME-Version: 1.0
In-Reply-To: <20100712172847.GA17423@merkur.ravnborg.org>
References: <201007120554.16459.vda.linux@googlemail.com>
	<20100712100301.db1d3980.randy.dunlap@oracle.com>
	<AANLkTin88f83UV4HcqKtaXS7F2hMTe8YVJPpE-XLmo5J@mail.gmail.com>
	<20100712172847.GA17423@merkur.ravnborg.org>
Date: Mon, 12 Jul 2010 19:40:50 +0200
Message-ID: <AANLkTin-Z_VfhLvp_6SB9Iq4F1ayYd8Xl9K7ND_rdolz@mail.gmail.com>
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

Documentation/kbuild/makefiles.txt says:

--- 6.1 Set variables to tweak the build to the architecture

...

    CFLAGS_KERNEL       $(CC) options specific for built-in

        $(CFLAGS_KERNEL) contains extra C compiler flags used to compile
        resident kernel code.

    CFLAGS_MODULE       $(CC) options specific for modules

        $(CFLAGS_MODULE) contains extra C compiler flags used to compile code
        for loadable kernel modules.

My reading of that file is these are *the* variables specifically
reserved for this role. Not CFLAGS, EXTRA_CFLAGS etc.

--
vda
