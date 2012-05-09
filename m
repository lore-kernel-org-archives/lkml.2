Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab2EIDw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 23:52:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64605 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab2EIDw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 23:52:28 -0400
MIME-Version: 1.0
In-Reply-To: <1336475689.1179.12.camel@mop>
References: <1336004953.4240.9.camel@mop> <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 May 2012 20:52:06 -0700
X-Google-Sender-Auth: WjKsk4ejE7W_KgxrVW3wfGUKHjw
Message-ID: <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Kay Sievers <kay@vrfy.org>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 4:14 AM, Kay Sievers <kay@vrfy.org> wrote:
>
> Yeah, we need to make sure, we never merge the (always racy)
> continuation printk() users with (non-racy) non-continuation users.
> Therefore KERN_CONT is required to suppress the newline and to merge the
> content with the earlier non-newline-terminated printk() line.

Why?

I really think this is just a bug in the new code.

KERN_CONT should not be needed if the previous printk didn't have a final "\n".

We made it easier to use printk for a reason a few months ago. The new
rules are:

 - If you have a KERN_<loglevel>, it *always* starts a new line, the
obvious exception being KERN_CONT

 - the loglevels *only* matter at the start of the printk - so if you
have '\n' embedded in a single printk, that changes nothing
what-so-ever. It's not line-based.

 - if you didn't have a '\n', and don't have a loglevel, KERN_CONT is implied.

Quite frankly, those three rules (a) make sense and (b) make things easy.

Breaking them now is a bug. Please don't go adding ugly KERN_CONT when
there really isn't any reason for it. Just fix the printk code you
broke.

                  Linus
