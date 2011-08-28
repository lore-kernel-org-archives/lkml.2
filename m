Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab1H1Vsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 17:48:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47593 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1H1Vsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 17:48:32 -0400
MIME-Version: 1.0
In-Reply-To: <20110828053624.GC12851@liondog.tnic>
References: <CAG1a4rs53RwkSxBvRQ5MrUbm7KEnpuEjw2fhSnT_1vqVPQrqgA@mail.gmail.com>
 <1314435638.2321.12.camel@thor.local> <CAG1a4rukteF+NmmTEhYT5yOmUYfDcbZ5qsghai1wm3ndpeiesg@mail.gmail.com>
 <20110828053624.GC12851@liondog.tnic>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Sun, 28 Aug 2011 17:47:59 -0400
Message-ID: <CAG1a4rv8YirPpyYP735Zn3gpp-kcvvECd=-haZ-qx90_99x8aQ@mail.gmail.com>
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
To: Borislav Petkov <bp@alien8.de>, Pavel Ivanov <paivanof@gmail.com>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        dri-devel@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 28, 2011 at 1:36 AM, Borislav Petkov <bp@alien8.de> wrote:
>> > With CONFIG_DRM_RADEON=y, the microcode is needed before it can be
>> > loaded from userspace, so it needs to be built into the kernel as well.
>>
>> How should I do that? I've tried to set all "m"s to "y" in .config and
>> still saw this issue. Should I set some special parameter?
>
> You need to add "radeon/CEDAR_pfp.bin" to CONFIG_EXTRA_FIRMWARE when you
> configure your kernel and enable CONFIG_FIRMWARE_IN_KERNEL.
>
> The radeon/CEDAR_pfp.bin file (+ leading directory, mind you) should
> most probably be located in /lib/firmware or to whatever you have set
> CONFIG_EXTRA_FIRMWARE_DIR so that Kbuild can find it (if not, you'll get
> a warning at the end of the kernel build). This way, it works for both
> radeon being =m and =y.

Everything else in /lib/firmware/radeon is needed after user space
become available?


Pavel
