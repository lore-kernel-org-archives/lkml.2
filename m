Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab0LQB6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:58:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943Ab0LQB56 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:57:58 -0500
MIME-Version: 1.0
In-Reply-To: <4d0662e511688484b3@agluck-desktop.sc.intel.com>
References: <4d0662e511688484b3@agluck-desktop.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Dec 2010 17:57:07 -0800
Message-ID: <AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>
Subject: Re: [concept & "good taste" review] persistent store
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        Borislav Petkov <bp@alien8.de>, David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 10:16 AM, Luck, Tony <tony.luck@intel.com> wrote:
>
> So before I embark on another round of code nit-picking, I'd like to
> get answers to the bigger questions:
>
>  Do we want/need this in Linux at all?
>
>  Is the overall approach OK, or do I need do this some other way?

So I have to say, it seemed interesting at first. I was like "ok, I
don't really see the point of making it a filesystem, but whatever -
it's pretty small".

Then I hit the

        /* Don't dump oopses to persistent store */
        if (reason == KMSG_DUMP_OOPS)
                return;

and I'm like "ok, this is just stupid".

The _only_ valid reason for persistent storage is for things like
oopses that kill the machine. Nothing else matters at all. If the
machine isn't dead, and it's not some critical oops, then why the
_hell_ would you ever use persistent storage? You're much better off
just using the regular disk.

So in the end, I really don't see any point at all to this thing. The
filesystem part is pointless (there are better filesystems around and
everybody has a disk or flash or whatever), and the only real upside
has been explicitly castrated.

                         Linus
