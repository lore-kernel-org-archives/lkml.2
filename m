Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab2JKSd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 14:33:59 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:55822 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759058Ab2JKSd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 14:33:56 -0400
Message-ID: <507710EA.1070900@shealevy.com>
Date: Thu, 11 Oct 2012 14:33:14 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20121010 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ivan Kalvachev <ikalvachev@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com> <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com> <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com> <4FE9169D.5020300@redhat.com> <20121002100319.59146693@r <CA+55aFwi2F1PYv39FxTKz1zu2tFqVDSAAxeSRW1BVK+==5H-6g@mail.gmail.com>
In-Reply-To: <CA+55aFwi2F1PYv39FxTKz1zu2tFqVDSAAxeSRW1BVK+==5H-6g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 06:37 PM, Linus Torvalds wrote:
> On Tue, Oct 2, 2012 at 2:03 PM, Ivan Kalvachev <ikalvachev@gmail.com> wrote:
>> I'm not kernel developer and probably my opinion would be a little
>> naive, but here it is.
>>
>> Please, make the kernel load firmware from the filesystem on its own.
> We probably should do that, not just for firmware, but for modules
> too. It would also simplify the whole "built-in firmware" thing
>
> Afaik, the only thing udev really does is to lok in
> /lib/firmware/updates and /lib/firmware for the file, load it, and
> pass it back to the kernel. We could make the kernel try to do it
> manually first, and only fall back to udev if that fails.
>
> Afaik, nobody ever does anything else anyway.
>

FWIW (and probably that's not much), the NixOS[0] distro doesn't 
currently use /lib/firmware. There is no /lib directory by default on 
NixOS, instead we create a new symlink tree representing the current 
system on each system change and symlink /run/current-system to that 
tree. We currently build udev/systemd with the 
--with-firmware-path=/run/current-system/firmware configuration-time 
option, but we also patch module-init-tools and kmod to respect the 
$MODULE_DIR env var and may do the same for firmware in the future. The 
way we do things has significant advantages (or at least we like to 
think so), but we already have exceptions for /bin/sh and /usr/bin/env, 
so I suspect we'll probably add in /lib/firmware if this functionality 
moves into the kernel.

[0]: https://nixos.org/

Cheers,
Shea Levy
