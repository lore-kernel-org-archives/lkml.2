Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab2BOSSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 13:18:30 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64906 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915Ab2BOSS2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 13:18:28 -0500
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
In-Reply-To: <20120211232740.GM23916@ZenIV.linux.org.uk>
References: <20110817163457.878854582@codeaurora.org> <20110817163521.165013232@codeaurora.org>
 <20120211232740.GM23916@ZenIV.linux.org.uk>
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Wed, 15 Feb 2012 12:18:07 -0600
Message-ID: <CAHrUA35E=0bfbe=4NS5FUcGqSGv-OEhP_6DM4+K4E1or9FyhdA@mail.gmail.com>
Subject: Re: hexagon: signal handling bugs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Richard Kuo <rkuo@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-hexagon@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 February 2012 17:27, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        1) unless I'm seriously misreading hexagon vm_entry.S, once we'd
> called do_notify_resume, we do *not* recheck if there's more work to
> be done.

>        2) sigreturn should *NOT* be restartable at all, or you'll get
....

Is there an architecture that "does this best"?  I (re-)wrote a
significant part of the hexagon sig-handling code, and I did it via
"surgical hacking": by reading the code for 4-6 other arches, and
trying to pick out the "best practices" of each.  But its easy to
build a Frankenstein when using body parts from mis-matched places, so
perhaps many of these mistakes were mine...

Perhaps its desirable to modify most/all architectures, so as to evoke
more commonality?  Some of the other, more minor arches sure did look
incomplete to me...

-- Linas
