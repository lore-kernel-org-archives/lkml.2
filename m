Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2GVTqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 15:46:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47686 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2GVTqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 15:46:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120722125843.GC18939@liondog.tnic>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
 <CA+55aFwZRvtpE2e3zNqvtobpPROqw_bOwNt+=DBzmScV0_rq=w@mail.gmail.com>
 <CACVXFVPupumYqeBwTwgK3C04VQBxOjkFMbaKQ-Gsz3teCWqQ=w@mail.gmail.com>
 <CA+55aFwte5bc-4FC758pBN3FbrtKQfwm_Mv_banekhL=kSF8kg@mail.gmail.com> <20120722125843.GC18939@liondog.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 22 Jul 2012 12:46:13 -0700
X-Google-Sender-Auth: OUQFwMxotzzhcEw49CNrFgnP2mg
Message-ID: <CA+55aFyOgWtyd=STeDrR687qKqu6TQ_q-aUTKcr_aQJNYrOhCg@mail.gmail.com>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot and resume
To: Borislav Petkov <borislav.petkov@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 5:58 AM, Borislav Petkov <bp@alien8.de> wrote:
>
> Question: is there any other reason
>
>   [besides maybe embedded people who care about each single Kb of memory
>    on the system]
>
> why we don't make this cache/uncache firmware thing *implicit*? That is,
> load it once at driver open time and keep it in memory during the whole
> driver's lifetime. And this all taken care of by the driver core, btw.

So some firmware is a *lot* more than "a few kB". We're talking
hundreds of kB, sometimes more. And to make matters worse, we keep it
in memory with vmalloc(), which is a limited resource on 32-bit
systems. So it can actually be worse than just the memory use itself.

Also, as you already mentioned, there's the "cache coherency" issue.
There are real advantages to reloading the firmware occasionally,
because it might have changed on disk. So..

I do think we might want to consider it, although I do suspect that we
do want to throw it out because of the problems with infinite caches.

                Linus
