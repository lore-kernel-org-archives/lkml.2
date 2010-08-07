Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab0HGEn2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 00:43:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42233 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab0HGEnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 00:43:25 -0400
MIME-Version: 1.0
In-Reply-To: <20100807040101.GA30520@merkur.ravnborg.org>
References: <20100804125156.GA23464@sepie.suse.cz>
	<AANLkTinN4npO7qfSa-42B-Cq5mKZX+--H0=1SuSrWTEP@mail.gmail.com>
	<20100807040101.GA30520@merkur.ravnborg.org>
Date: Fri, 6 Aug 2010 21:43:24 -0700
Message-ID: <AANLkTinOWBfsncSZw3bvHa6Mp+eb5dzibKSV15OKgW2M@mail.gmail.com>
Subject: Re: [GIT] kbuild: kconfig changes
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, JBeulich@novell.com,
        aris@redhat.com, catalin.marinas@arm.com, jacmet@sunsite.dk,
        justinmattock@gmail.com, lizf@cn.fujitsu.com, ulfalizer.lkml@gmail.com,
        zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 9:01 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>>
>> This change prevents some the minimal defconfig options from working.
>> Specifically our usb gadget drivers do not get set.
>
> Can you help me reproduce this?
>
> I have found an issue with choice values in combination with
> tristate logic that fails. I hope this is something similar.
>

It is probably the same problem. The gadget driver that was not set is
not buildable as a module (it is not in the mainline kernel). If I
select another gadget driver instead it just gets changed to build as
a module instead.

If you create a file, arch/arm/configs/test_defconfig with the following:
CONFIG_MODULES=y
CONFIG_USB_GADGET=y
CONFIG_USB_MASS_STORAGE=y

then "make test_defconfig" results in .config having:
CONFIG_USB_MASS_STORAGE=m

 (at least if you are set up to compile for arm)

-- 
Arve Hjønnevåg
