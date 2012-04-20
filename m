Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2DTKvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 06:51:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49543 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2DTKvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 06:51:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9tzma3o0aeikrqxadGae7MF_QUeQE0_k2ZkgS2tCOcjn9g@mail.gmail.com>
References: <1334607965-9582-1-git-send-email-mjg@redhat.com>
	<CAMuHMdVYSajTYmfXjtVRXhz0u=xW0LbQ5BxjR=n7PP77o0dXhw@mail.gmail.com>
	<CAMuHMdUsMy1i+DSYt+tjGL-JX+DBY=v1JyMEPSyf8RwYCEkvxg@mail.gmail.com>
	<CAPM=9tzma3o0aeikrqxadGae7MF_QUeQE0_k2ZkgS2tCOcjn9g@mail.gmail.com>
Date: Fri, 20 Apr 2012 11:51:00 +0100
Message-ID: <CAPM=9txHkpmTavs+PjW4jHzufQ_R7yYDU3DATVAhbb5MqcJG0Q@mail.gmail.com>
Subject: Re: [PATCH V2 1/4] vgaarb: Add support for setting the default video device
From: Dave Airlie <airlied@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, airlied@redhat.com,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 11:49 AM, Dave Airlie <airlied@gmail.com> wrote:
> On Wed, Apr 18, 2012 at 10:44 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Wed, Apr 18, 2012 at 11:37, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>> On Mon, Apr 16, 2012 at 22:26, Matthew Garrett <mjg@redhat.com> wrote:
>>>> --- a/include/linux/vgaarb.h
>>>> +++ b/include/linux/vgaarb.h
>>>> @@ -31,6 +31,7 @@
>>>>  #ifndef LINUX_VGA_H
>>>>  #define LINUX_VGA_H
>>>>
>>>> +#include <video/vga.h>
>>>
>>> Is this include really needed? x86_64/allmodconfig builds fine without it.
>>>
>>> It causes m68k/allmodconfig to fail with:
>>>
>>> In file included from include/linux/vgaarb.h:35,
>>>                 from drivers/gpu/drm/drm_irq.c:43:
>>> include/video/vga.h: In function ‘vga_mm_r’:
>>> include/video/vga.h:242: error: implicit declaration of function ‘z_readb’
>>> include/video/vga.h: In function ‘vga_mm_w’:
>>> include/video/vga.h:247: error: implicit declaration of function ‘z_writeb’
>>> include/video/vga.h: In function ‘vga_mm_w_fast’:
>>> include/video/vga.h:253: error: implicit declaration of function ‘z_writew’
>>> make[1]: *** [drivers/gpu/drm/drm_irq.o] Error 1
>>>
>>> http://kisskb.ellerman.id.au/kisskb/buildresult/6127136/
>>>
>>> Currently <video/vga.h> has a crude hack to make cirrusfb work on Amiga,
>>> but that's the only VGA support m68k has.
>>> There's also no <asm/vga.h>, so m68k/allmodconfig with CONFIG_AMIGA
>>> disabled now fails with:
>>>
>>> In file included from include/linux/vgaarb.h:34,
>>>                 from drivers/gpu/drm/drm_irq.c:42:
>>> include/video/vga.h:23:21: error: asm/vga.h: No such file or directory
>>> make[1]: *** [drivers/gpu/drm/drm_irq.o] Error 1
>>>
>>> Removing the #include <video/vga.h> fixes both cases.
>>
>> Anyway, I'll move the hack for cirrusfb on Amiga to <asm/vga.h> on m68k.
>>
>> You still may want to remove the include of <video/vga.h> if it's not needed.
>
> I don't think its necessary, I'm dropping it here. should be gone in
> -next soon after.
>

Of course then I read the rest of the patches, and yes patch 4/4 would need it
so we pick up the __ARCH_HAS define, unless we can think of a better
place to put that.

Dave.
> Dave.
