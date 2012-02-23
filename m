Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2BWAL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 19:11:26 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:54068 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab2BWALZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 19:11:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mcgrathr@google.com designates 10.229.78.215 as permitted sender) smtp.mail=mcgrathr@google.com; dkim=pass header.i=mcgrathr@google.com
MIME-Version: 1.0
In-Reply-To: <CAObL_7Gc0U2JMBQr_kbcVUJwyJq7LRfgdFr+84LR=ec4kSCwEA@mail.gmail.com>
References: <1329845435-2313-1-git-send-email-wad@chromium.org>
 <1329845435-2313-7-git-send-email-wad@chromium.org> <9edbabb2262e3d91a7b8c75dbec03d7f.squirrel@webmail.greenhost.nl>
 <CABqD9hY1n9EOAKKT0r9Ev+azhBMnLMAM_FgDNe5we9upVePk_A@mail.gmail.com> <CAObL_7Gc0U2JMBQr_kbcVUJwyJq7LRfgdFr+84LR=ec4kSCwEA@mail.gmail.com>
From: Roland McGrath <mcgrathr@google.com>
Date: Wed, 22 Feb 2012 16:11:01 -0800
Message-ID: <CAB=4xhpgfrgEf7BhYUu5BYR1QrzBZk_nLk43UDAZ9uXC4dJGwA@mail.gmail.com>
Subject: Re: [PATCH v10 07/11] signal, x86: add SIGSYS info and make it synchronous.
To: Andrew Lutomirski <luto@mit.edu>
Cc: Will Drewry <wad@chromium.org>, Indan Zupancic <indan@nul.nu>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        keescook@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 3:38 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> I wonder if it would be helpful to change the semantics of RET_KILL
> slightly.  Rather than killing via do_exit, what if it killed via a
> forcibly-fatal SIGSYS?  That way, the parent's waitid() / SIGCHLD
> would indicate CLD_KILLED with si_status == SIGSYS.  The parent could
> check that and report that the child was probably compromised.

That would be better.  But it is certainly a more complex code path, which
makes the security weenies twitch.  As to concrete issues, any "normal"
path needs the changes that are maybe pending from Oleg to make it actually
abort the syscall instead of completing it before getting to the signal path.
