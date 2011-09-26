Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab1IZWre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 18:47:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64404 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1IZWrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 18:47:33 -0400
MIME-Version: 1.0
In-Reply-To: <201109270024.55418.rjw@sisk.pl>
References: <s5hmxdzyyzx.wl%tiwai@suse.de> <201109212048.23074.rjw@sisk.pl>
 <CAE9FiQVy4D0NhaN=PvPK_+L4Jv=+7huLy9U--LYW49GFZ9TyaQ@mail.gmail.com> <201109270024.55418.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 26 Sep 2011 15:47:12 -0700
X-Google-Sender-Auth: glTPpuhbvd2WQJVL93fQLHhj1uc
Message-ID: <CA+55aFyyeRyvooTY_Gb9xnOHt6AyCoQEtNFW2NPyb=M4gvVshQ@mail.gmail.com>
Subject: Re: S4 resume broken since 2.6.39 (3.1, too)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai.lu@oracle.com>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        oneukum@suse.de, x86@kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 3:24 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> So, in my opinion we should simply apply the Takashi's patch at this
> point and revisit the kdump issue later, when we actually know how to do
> the right thing.

Applying that trivial patch certainly looks fine, especially since it
also avoids some arbitrary differences between x86-64 and x86-32.

That said, the whole code looks *very* confusing, and I have to say
that the commit logs there are also totally unreadable and not very
explanatory at all.

It does seem like the code is simply buggy: it "allocates" the page
tables from the end of memory, but it seems to want to do that before
they have been mapped. Which makes perfect sense, since the whole
point of allocating them is to be *able* to map all the memory.

So using that

    good_end = max_pfn_mapped << PAGE_SHIFT;

would seem to be a good idea regardless. I'm not sure how the old code
is even supposed to work. That said - why is this a problem only for
S4 resume?

Yinghai?

                    Linus
