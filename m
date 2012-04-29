Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab2D2Qmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 12:42:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab2D2Qmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 12:42:45 -0400
Date: Sun, 29 Apr 2012 18:41:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120429164155.GC15792@redhat.com>
References: <20120420160848.GG6871@ZenIV.linux.org.uk> <20120420164239.GH6871@ZenIV.linux.org.uk> <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com> <20120420180748.GI6871@ZenIV.linux.org.uk> <20120423180150.GA6871@ZenIV.linux.org.uk> <20120424072617.GB6871@ZenIV.linux.org.uk> <20120426183742.GA324@redhat.com> <20120426231942.GJ6871@ZenIV.linux.org.uk> <20120427172444.GA30267@redhat.com> <20120427184528.GL6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427184528.GL6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Al Viro wrote:
>
> 	BTW, I'm somewhat tempted to do the following: *ALL* calls of
> tracehook_signal_handler() are now immediately preceded by block_signals().
> Moreover, tracehook_signal_handler(...., 0) is currently a no-op, so
> it could be painlessly added after the remaining block_signals() instances.
> How about *folding* block_signals() (along with clear_restore_sigmask())
> into tracehook_signal_handler()?

Oh, please no. Imho, these two have nothing to do with each other.

Besides, at least on x86 tracehook_signal_handler's logic is not exactly
right and should be fixed.

And we are going to kill tracehook.h. While personally I do not think
this is the good idea, but the matter of fact is that tracehooks are
already destroyed.

Oleg.

