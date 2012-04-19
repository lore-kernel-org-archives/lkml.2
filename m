Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab2DSW6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:58:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48998 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2DSW6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:58:41 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbKz4GNs-mFj5=dCpRe_XLgoKZZz-8GM+FqTMTDBKqJNJw@mail.gmail.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
 <20120419092255.GA29542@aftab> <20120419092630.GD29542@aftab>
 <4F904541.2030200@zytor.com> <CA+55aFwMsm7zVqPjKptm38zJAbJpF=9e51ew7BP6S5YnoJa3ig@mail.gmail.com>
 <20120419173802.GI3221@aftab.osrc.amd.com> <4F90527B.7020005@zytor.com>
 <CA+55aFxhY1Ug5esj==Sm=o1Epg+NFnvFs74syqRxbYDbPQJEFA@mail.gmail.com>
 <9ff2e09c-57e4-455e-8614-1b3b17b652f4@email.android.com> <4F9072CA.6030903@gmail.com>
 <4F908EA5.4060507@zytor.com> <CA+8MBbKz4GNs-mFj5=dCpRe_XLgoKZZz-8GM+FqTMTDBKqJNJw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Apr 2012 15:58:20 -0700
X-Google-Sender-Auth: TeCPKAVbHaZS2jtQsGcxxoAq-Ww
Message-ID: <CA+55aFx8EDb3MOrpky7aBf28=5XQ41ebuunO5aYrnUY1haVzcA@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86, extable: Handle early exceptions
To: Tony Luck <tony.luck@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Daney <ddaney.cavm@gmail.com>,
        Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 3:47 PM, Tony Luck <tony.luck@gmail.com> wrote:
>
> How many entries are in the extable for a typical module?  Perhaps it might
> make sense to bundle them all into one sorted combined table? Of course
> you would have to have a way to squeeze them back out of the combined
> table at module unload time.
>
> This moves the cost to module load/unload time ... which is hopefully rare
> compared to table lookup.

Using a traditional chained hash-table might be very amenable to this
kind of situation. It's much easier to populate and doesn't have the
size issues. And realistically, we can probably size the hash table
for just the built-in kernel, because modules seldom have nearly as
many exception table entries, so adding them later to a fixed-size
table likely won't be too painful.

In fact, doing an "objdump" on the few modules I have, I didn't find a
*single* exception table entry. Maybe I did something wrong? Isn't it
the __ex_table in modules too?

(Admittedly, I avoid modules like the plague, so I don't tend to have
very many modules, and the ones I do have tend to be pretty limited.
So my module usage is absolutely not representative even if I think it
should be ;^).

                   Linus
