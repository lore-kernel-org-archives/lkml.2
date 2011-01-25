Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1AYUer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:34:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618Ab1AYUeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:34:46 -0500
MIME-Version: 1.0
In-Reply-To: <20110125134748.GA10051@laptop>
References: <20110125134748.GA10051@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Jan 2011 06:25:19 +1000
Message-ID: <AANLkTinU0KYiCd4p=z+=ojbkeEoT2G+CAYvdRU02KJEn@mail.gmail.com>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk upon panic
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86-ML <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 11:47 PM, Ahmed S. Darwish <darwish.07@gmail.com> wrote:
>
> I've faced some very early panics in latest kernel. Being a run of the mill
> x86 laptop, the machine is void of debugging aids like serial ports or
> network boot.
>
> As a possible solution, below patches prototypes the idea of persistently
> storing the kernel log ring to a hard disk partition using the enhanced BIOS
> 0x13 services.

Quite frankly, I'm not likely to _ever_ merge anything like this.

Over the years, many people have tried to write things to disk on
oops. I refuse to take it. No way in hell do I want the situation of
"the system is screwed, so let's overwrite the disk" to be something
the kernel I release might do. It's crazy. That disk is a lot more
important than the kernel, and overwriting it when we might have
serious memory corruption issues or something is not a thing I feel is
appropriate.

I also don't think that it's safe to use the BIOS routines. That's not
the environment they have been tested in  - the boot environment is
very different from the "running kernel" setup. Devices will have been
possibly remapped, virtual mappings are different, things are just
very random.

Some vendors have taken things like this in the past, but I just
wanted to say that I think it's too damn scary. I _really_ don't see
the point.

If you want to do the BIOS services thing, do it for video: copy the
oops to low RAM, return to real mode, re-run the graphics card POST
routines to initialize text-mode, and use the BIOS to print out the
oops.  That is WAY less scary than writing to disk.

                              Linus
