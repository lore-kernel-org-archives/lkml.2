Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1FNTE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 15:04:29 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53904 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753246Ab1FNTEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 15:04:25 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19FPoJtQn1Fdg0avVxTKBRIkp4VT67q2hOupHh1E3
	7fGazD1xV6Joxz
Message-ID: <4DF7B0B4.4060002@gmx.de>
Date: Tue, 14 Jun 2011 19:04:20 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Francis Moreau <francis.moro@gmail.com>
Subject: Re: Possible deadlock when suspending framebuffer
References: <BANLkTiko+2AM8dq8jP5xjbTcCM63hBAK=A@mail.gmail.com> <BANLkTimny9nzr23TufH1kMcsk57M3NXuaA@mail.gmail.com>
In-Reply-To: <BANLkTimny9nzr23TufH1kMcsk57M3NXuaA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 06/14/2011 06:15 PM, Linus Torvalds wrote:
> Paul, fbdev people.. Comments? This was sent to me and lkml, the right
> people probably didn't see it.

Sounds very familiar. Indeed a quick glance at my archive revealed 2 
approaches/patches dealing with similar issues
http://marc.info/?l=linux-fbdev&m=129539210207429&w=2
http://marc.info/?l=linux-fbdev&m=129700789632450&w=2

I did not have time to verify that those do actually get those things right 
everywhere but the first one looks good and should also solve this issue I think.


Regards,

Florian Tobias Schandinat

>
> I doubt it's a big problem in practice, but..
>
>                        Linus
>
> On Tue, Jun 14, 2011 at 6:10 AM, Francis Moreau<francis.moro@gmail.com>  wrote:
>> Hello,
>>
>> I noticed that a possible deadlock can happen when the current frame
>> buffering is being suspended and a new frambuffer device is being
>> registred at the same time.
>>
>> When suspending the current frambuffer by doing : echo 1
>>> /sys/class/graphics/fb0/state, the kernel actually takes the
>> following locks in that order: console_lock, lock_fb_info (see
>> store_fbstate()).
>>
>> However when a new framebuffer is coming in, the lock sequence is:
>> lock_fb_info (taken by do_remove_conflicting_framebuffer()),
>> console_lock() (taken by unbind_console).
>>
>> I don't know how this should be fixed though...
>>
>> Thanks
>> --
>> Francis
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

