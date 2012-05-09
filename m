Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab2EIEMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 00:12:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39795 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2EIEMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 00:12:13 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 9 May 2012 06:11:51 +0200
Message-ID: <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Greg Kroah-Hartmann <greg@kroah.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 5:52 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> KERN_CONT should not be needed if the previous printk didn't have a final "\n".
>
> We made it easier to use printk for a reason a few months ago. The new
> rules are:
>
>  - If you have a KERN_<loglevel>, it *always* starts a new line, the
> obvious exception being KERN_CONT
>
>  - the loglevels *only* matter at the start of the printk - so if you
> have '\n' embedded in a single printk, that changes nothing
> what-so-ever. It's not line-based.
>
>  - if you didn't have a '\n', and don't have a loglevel, KERN_CONT is implied.
>
> Quite frankly, those three rules (a) make sense and (b) make things easy.

Is there a reason to keep KERN_CONT under this set of rules at all?

I'm guessing that there are very few places that have a final '\n' but
still want to use KERN_CONT, and even in that case it should be
trivially easy to fix them up.

Besides that, from what I understand, KERN_CONT isn't really needed.
