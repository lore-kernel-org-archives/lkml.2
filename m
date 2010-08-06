Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934989Ab0HFRSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:18:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771Ab0HFRSU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:18:20 -0400
MIME-Version: 1.0
In-Reply-To: <201008052037.o75KbxSS022005@hera.kernel.org>
References: <201008052037.o75KbxSS022005@hera.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Aug 2010 10:17:27 -0700
Message-ID: <AANLkTimZF5U-AmD6200gnTuNzX5nUqVqEo_NmiH3rz5n@mail.gmail.com>
Subject: Re: [GIT PULL] x86/asm for 2.6.36
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: stable@kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Avi Kivity <avi@redhat.com>, Brian Gerst <brgerst@gmail.com>,
        Glauber Costa <glommer@redhat.com>, Greg KH <gregkh@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jeff Dike <jdike@addtoit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Palfrader <peter@palfrader.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zachary Amsden <zamsden@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 1:37 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-asm-for-linus
>
> H. Peter Anvin (7):
>      x86, asm: Clean up and simplify set_64bit()

Hmm. This seems to cause compiler warnings for me on x86-64:

  drivers/pci/intr_remapping.c: In function ‘modify_irte’:
  drivers/pci/intr_remapping.c:314: warning: passing argument 1 of
‘set_64bit’ from incompatible pointer type
  /home/torvalds/v2.6/linux/arch/x86/include/asm/cmpxchg_64.h:6: note:
expected ‘volatile u64 *’ but argument is of type ‘long unsigned int
*’

and I'm not clear on the reason for that function prototype change.

                          Linus
