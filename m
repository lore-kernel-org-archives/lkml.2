Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab1FHW62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 18:58:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103Ab1FHW6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 18:58:25 -0400
MIME-Version: 1.0
In-Reply-To: <4DEFEEE7.1030703@linux.intel.com>
References: <20110608193833.GA29855@srcf.ucam.org> <4DEFD220.5040507@kernel.org>
 <20110608195250.GB30256@srcf.ucam.org> <4DEFD58D.5060402@kernel.org>
 <20110608200903.GA30694@srcf.ucam.org> <4DEFDA4A.9080500@kernel.org>
 <20110608203037.GA31052@srcf.ucam.org> <4DEFDD69.7010000@kernel.org>
 <20110608204244.GA31484@srcf.ucam.org> <BANLkTikfbSsgGgNEQ3GVD=HOPn1Dz_xh+g@mail.gmail.com>
 <20110608212813.GB32056@srcf.ucam.org> <BANLkTikbx6xm+NY34ATN7YkJyjPp9CSXTw@mail.gmail.com>
 <4DEFEEE7.1030703@linux.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Jun 2011 15:57:25 -0700
Message-ID: <BANLkTi=0NyXLRpxnP=dmSgeStNtxYMKPuA@mail.gmail.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Yinghai Lu <yinghai@kernel.org>,
        Jim Bos <jim876@xs4all.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 2:51 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> However, I suspect that what we *should* do is carry an kernel EFI stub
> to go along with the BIOS stub... otherwise we're forever at mercy of
> getting all the boot loader authors to change in lockstep, and there are
> specific ones which are notoriously hard to work with.

Yes, that would probably be a good approach. We obviously have some
low-level asm code for the BIOS case that is technically linked into
the kernel, but is running before the kernel boots and not really
"part" of the kernel. Doing something similar for EFI support sounds
entirely sane to me.

                      Linus
