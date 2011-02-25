Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab1BYAzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 19:55:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755669Ab1BYAzi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 19:55:38 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=wbtcAOmYE8UF7ynPZ_nR3ZXxVRBcuMVGNK4u0@mail.gmail.com>
References: <AANLkTi=TTZ57d1wUz1uH3R6igN8O77iDvSLMW=t86g9V@mail.gmail.com>
 <20110222140349.GA20708@kryptos.osrc.amd.com> <AANLkTikESHHfjBqoLFOno6qQz-NXEAo-wBY5JEeAW61N@mail.gmail.com>
 <AANLkTinh4pF7iaUGMcv_9gPy+VBD5POsTHbF_2zPJ17r@mail.gmail.com>
 <AANLkTi=Ys4mb4pc28cH4NMdtMgb2KewJbkXEGJmEP4J0@mail.gmail.com>
 <AANLkTinxHVDwSCouTaZEvR3yTJnSPAas9z6JauGDdS7=@mail.gmail.com>
 <AANLkTinD2cC9dGg2eBtZQhWvhSsuH2BcWDj8byLhWWso@mail.gmail.com>
 <AANLkTin8+F003-jFoQ0pd9OjN1oT2iqyNjd58SDJZuMK@mail.gmail.com>
 <AANLkTinzse1ZfEvAuWfuZ_8VDypcnD5poU6GwOdYTgWh@mail.gmail.com> <AANLkTi=wbtcAOmYE8UF7ynPZ_nR3ZXxVRBcuMVGNK4u0@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Feb 2011 16:54:44 -0800
Message-ID: <AANLkTin7+AHAqKz5T-1_=N6tqPytyT4ooqyJuhHC6ET=@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc6
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-fbdev@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        Borislav Petkov <bp@amd64.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 4:48 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index e2bf953..e8f8925 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1511,6 +1511,7 @@ void remove_conflicting_framebuffers(struct
> apertures_struct *a,
>                               "%s vs %s - removing generic driver\n",
>                               name, registered_fb[i]->fix.id);
>                        unregister_framebuffer(registered_fb[i]);
> +                       registered_fb[i] = NULL;
>
> Tested the patch, and now I get this:
> dmesg: http://pastebin.com/ieMNrA7C
>
> [   12.252328] BUG: unable to handle kernel NULL pointer dereference
> at 00000000000003b8
> [   12.252342] IP: [<ffffffff81311178>] fb_mmap+0x58/0x1d0

Ok, goodie.

Or not so goodie, but it does make it clear that yeah, the fb code
seems to be using stale pointers from that registered_fb[] array, and
the whole unregistration process is just racing with people using it.

Herton had that much bigger patch, can you test it?

                         Linus
