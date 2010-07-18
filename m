Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab0GRWbe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 18:31:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757435Ab0GRWbd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 18:31:33 -0400
MIME-Version: 1.0
In-Reply-To: <20100718221111.19BC24B2C9@magilla.sf.frob.com>
References: <20100718221111.19BC24B2C9@magilla.sf.frob.com>
Date: Sun, 18 Jul 2010 15:31:24 -0700
Message-ID: <AANLkTinZG9PaA1HexpRtjjm52Q9Oq-GCj4i2sIs1sE1R@mail.gmail.com>
Subject: Re: [PATCH] x86: kprobes: fix swapped segment registers in kretprobe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 18, 2010 at 3:11 PM, Roland McGrath <roland@redhat.com> wrote:
>
> [PATCH] x86: kprobes: fix swapped segment registers in kretprobe
>
> In commit f007ea26, the order of the %es and %ds segment registers
> got accidentally swapped, so synthesized 'struct pt_regs' frames
> have the two values inverted.  It's almost sure that these values
> never matter, and that they also never differ.  But wrong is wrong.

Heh, yes. ES and DS are almost guaranteed to be the same, or string
instructions act oddly. But I could imagine that some wine usage could
trigger this. Of course, you'd also have to have probes etc.

Regardless - pulled,

                  Linus
