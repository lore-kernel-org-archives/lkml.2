Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2JNSlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 14:41:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab2JNSk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 14:40:58 -0400
Date: Sun, 14 Oct 2012 20:42:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dl8bcu@dl8bcu.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/1] (Was: [regression] boot failure on alpha, bisected)
Message-ID: <20121014184218.GA17416@redhat.com>
References: <20121006204736.GA1830@ds20.borg.net> <20121012160337.GA30881@redhat.com> <20121012221843.GJ2616@ZenIV.linux.org.uk> <20121014183539.GA16804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121014183539.GA16804@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14, Oleg Nesterov wrote:
>
> Again, this is fine. But why "else" ? It seems that
>
> 			if (thread_flags & _TIF_SIGPENDING) {
> 				do_signal(regs, r0, r19);
> 				r0 = 0;
> 			}
>
> 			if (thread_flags & _TIF_NOTIFY_RESUME) {
> 				clear_thread_flag(TIF_NOTIFY_RESUME);
> 				tracehook_notify_resume(regs);
> 			}
>
> makes a bit more sense?

Except I meant "if (_TIF_NOTIFY_RESUME)" first.

Oleg.

