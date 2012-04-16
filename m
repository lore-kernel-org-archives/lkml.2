Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab2DPPCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:02:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61876 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2DPPCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:02:41 -0400
MIME-Version: 1.0
In-Reply-To: <4F8BBB4D.5090409@hitachi.com>
References: <tip-4zpgimmz8xv7b5c920el7s45@git.kernel.org> <CA+55aFxnv5Wrix=uREQsEg+tSBE8SFvy0v_76csv3hrnmPYG2A@mail.gmail.com>
 <CA+55aFwcf2uPCccCVrNdCENZVKyev=ARprNj=5zwp5vxD942pw@mail.gmail.com>
 <20120414010410.GB22114@infradead.org> <20120414085519.GB28505@gmail.com>
 <20120414162851.GD22114@infradead.org> <4F8BBB4D.5090409@hitachi.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Apr 2012 08:02:20 -0700
X-Google-Sender-Auth: 8MP3hhKq4e8nBmnJNzuswQedKco
Message-ID: <CA+55aFy5pfzKfaDCc0jbQ5_+_+MMso_XqRcR-KqkZMwcSXAbPQ@mail.gmail.com>
Subject: Re: [tip:perf/core] perf ui annotate browser: Allow toggling addr
 offset view
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, efault@gmx.de, peterz@infradead.org,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 11:25 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
>
> If we can ignore permissions, we can check whether the instruction
> at the event address is modified or not in /dev/mem.
> And that is also useful for modules. That can be done in userspace
> with using setuid'd tool.

No, please don't make a setuid tool for this.

It really would be *much* better if you could parse the
'altinstructions' section. You already have a lot of ELF parsing code.

Trust me, that's much better than trying to read the actual kernel
image - and makes things like off-line analysis easier too. The only
thing you need is the active CPU features (default to "current CPU
features"), rather than having to have the whole kernel image.

And no permission issues.

                        Linus
