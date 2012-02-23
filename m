Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2BWWQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:16:11 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:60529 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab2BWWQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:16:08 -0500
Message-ID: <fe2d4b97d84c1e8053c397a20eec7ac8.squirrel@webmail.greenhost.nl>
In-Reply-To: <CABqD9hbsZTtkFzM_8rHqAWjZhiV0iWb6s1eMF9LriH-NybrorA@mail.gmail.com>
References: <1329845435-2313-1-git-send-email-wad@chromium.org>
    <1329845435-2313-7-git-send-email-wad@chromium.org>
    <9edbabb2262e3d91a7b8c75dbec03d7f.squirrel@webmail.greenhost.nl>
    <CABqD9hY1n9EOAKKT0r9Ev+azhBMnLMAM_FgDNe5we9upVePk_A@mail.gmail.com>
    <CAObL_7Gc0U2JMBQr_kbcVUJwyJq7LRfgdFr+84LR=ec4kSCwEA@mail.gmail.com>
    <CAGXu5jJQrnkCZtcLqK8NEihRgB25C12b0nKp+XWXV_=4QfcVoA@mail.gmail.com>
    <CABqD9hbC8v-rUBW+4T_-EwDwe1+VDohQZweQ-cxOg2A-iDH5CQ@mail.gmail.com>
    <CAGXu5j+fQqkrrKSm3kmCkCcZJKo-VZjL6kkrOD81LZYBY7tf2g@mail.gmail.com>
    <4F45887A.5010809@zytor.com>
    <CAB=4xhq1sm_ewZ_8Kerf2aN7nGx+DEENse7Lqg5N0wuvqtzUAw@mail.gmail.com>
    <4F459109.1060205@zytor.com>
    <CAB=4xhqndEw3tMPaUcdZh_jcjQcoK_=7GwOc5gVhnz5o_4eWzQ@mail.gmail.com>
    <CABqD9hbsZTtkFzM_8rHqAWjZhiV0iWb6s1eMF9LriH-NybrorA@mail.gmail.com>
Date: Thu, 23 Feb 2012 23:15:51 +0100
Subject: Re: [PATCH v10 07/11] signal, x86: add SIGSYS info and make it
 synchronous.
From: "Indan Zupancic" <indan@nul.nu>
To: "Will Drewry" <wad@chromium.org>
Cc: "Roland McGrath" <mcgrathr@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Kees Cook" <keescook@chromium.org>,
        "Andrew Lutomirski" <luto@mit.edu>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, mingo@redhat.com,
        oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net,
        tglx@linutronix.de, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com,
        markus@chromium.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 71684ae416b12bc74806129cb02de027
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, February 23, 2012 20:26, Will Drewry wrote:
> Seems like there's an argument for another return code,
> SECCOMP_RET_CORE, that resets/unblocks the SIGSYS handler since the
> existing TRAP and KILL options seem to cover the other paths (signal
> handler and do_exit).

What about making SECCOMP_RET_TRAP dump core/send SIGSYS if there is
no tracer with PTRACE_O_SECCOMP set? And perhaps go for a blockable
SIGSYS? That way you only have KILL, ERRNO and TRAP, with the last
one meaning deny, but giving someone else a chance to do something.
Or is that just confusing?

I don't think there should be too many return values, or else you
put too much runtime policy into the filters.

Sending SIGSYS is useful, but it's quite a bit less useful if user
space can't handle it in a signal handler, so I don't think it's
worth it to make a unblockable version.

Greetings,

Indan


