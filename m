Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab1BWRQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:16:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56876 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab1BWRQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:16:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UPp8vhV5JF68m4peoMxqcJNIWlw8sobqzvLiOUgv7T5vVORYd9RFE7fSZUom2qx4jU
         FeBfbkqnlarRhq2zRQeiIdjKdkT+Ci7vX1cTmjC00sOuEvfNr49oQgKemB5kgQoxtBgb
         8ziLKigwCheWhyqrLSSWCC+0OmRi5wBv/uEz0=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Ys4mb4pc28cH4NMdtMgb2KewJbkXEGJmEP4J0@mail.gmail.com>
References: <AANLkTi=TTZ57d1wUz1uH3R6igN8O77iDvSLMW=t86g9V@mail.gmail.com>
	<20110222140349.GA20708@kryptos.osrc.amd.com>
	<AANLkTikESHHfjBqoLFOno6qQz-NXEAo-wBY5JEeAW61N@mail.gmail.com>
	<AANLkTinh4pF7iaUGMcv_9gPy+VBD5POsTHbF_2zPJ17r@mail.gmail.com>
	<AANLkTi=Ys4mb4pc28cH4NMdtMgb2KewJbkXEGJmEP4J0@mail.gmail.com>
Date: Wed, 23 Feb 2011 19:16:05 +0200
Message-ID: <AANLkTinxHVDwSCouTaZEvR3yTJnSPAas9z6JauGDdS7=@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc6
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@redhat.com>, linux-fbdev@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 6:32 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Feb 22, 2011 at 9:42 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>> General protection fault:
>> http://i.imgur.com/TBJ6y.jpg
>>
>> dmesg: http://pastebin.com/qD8pR8QH
>> config: http://pastebin.com/XEurtHWi
>
> That's drivers/video/fbmem.c: fb_release(), and the "Code:"
> disassembly shows that it is
>
>  1b:   e8 f7 c0 29 00          callq  xyz
>  20:   48 8b 93 b8 03 00 00    mov    0x3b8(%rbx),%rdx
>  27:*  48 8b 42 10             mov    0x10(%rdx),%rax     <-- trapping instruction
>
> which corresponds to
>
>        mutex_lock(&info->lock);
>        if (info->fbops->fb_release)
>                info->fbops->fb_release(info,1);
>
> so it looks like 'info->fbops' is invalid. It's in %rdx, and is
> 0x00d000ae00b500c2, which is definitely not a valid pointer. Looks
> like some bad corruption (looks like a sequence of 16-bit numbers, but
> it could be anything).
>
> Looks like nouveafb took over from vesafb. Did you do anything special
> to trigger this?

No. Just boot the system.

>
> Also, you do seem to have some extra patches (yama at the least). Anything else?

I used git clone, nothing else.
First time 2.6.38-rc6 was working.
After an update from ubuntu I get that error at boot.

The dmesg is from Ubuntu 11.04 with their kernel and is working fine.

>
>                            Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
