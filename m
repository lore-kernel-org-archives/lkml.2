Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab2BBT2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:28:30 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60721 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab2BBT22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:28:28 -0500
MIME-Version: 1.0
In-Reply-To: <CADdbW+Eaab4ucATwX+ao-P+kcms-AJKQMGZr2E6g73gLACZSZg@mail.gmail.com>
References: <4E68A6E8.9020700@pobox.com> <20110908165155.f661a738.akpm@linux-foundation.org>
 <4F26B162.4050000@pobox.com> <4F274E28.2010200@gmail.com> <4F27D9AD.1020806@pobox.com>
 <CADdbW+Eaab4ucATwX+ao-P+kcms-AJKQMGZr2E6g73gLACZSZg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 2 Feb 2012 11:28:08 -0800
X-Google-Sender-Auth: EZFjVmEw9rv1IdUK1b6t14QHd4w
Message-ID: <CA+55aFytBRZiQUcnWtSYnxqXUJCfVuS4f5tq=QUNG2GfbF1mhA@mail.gmail.com>
Subject: Re: ASM1083 PCIx-PCI bridge interrupts - widespread problems
To: Edward Donovan <edward.donovan@numble.net>
Cc: Chris Palmer <chris.palmer@pobox.com>,
        Robert Hancock <hancockrwd@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        ghost3k@ghost3k.net, linux-kernel@vger.kernel.org, keve@irb.hu,
        bjorn.ottervik@gmail.com, kaneda@freemail.hu,
        jeroen.vandenkeybus@gmail.com, clemens@ladisch.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 11:20 AM, Edward Donovan
<edward.donovan@numble.net> wrote:
>
> If we end up helpless with this chip, will we at least warn the user
> that it's known to be buggy?  I dont' know if there's a standard
> procedure when documenting bad hardware.

That's probably a good idea.

That said, the "switch to polled mode and then try to reenable every
100ms" approach sounds like a good idea regardless. The more robust we
can be, the better.

I realize that the people with *this* particular problem would
probably want to reenable them even more often than 100ms or so, but
that could lead to problems for people with seriously screaming
interrupts (which has definitely happened too), so we need to balance
those two issues out against each other.

And we'd probably need to limit the warning messages if we start
re-enabling it - so that people with constantly screaming interrupts
don't get a constant stream of 10 "nobody cared, disabling" messages
per second.

So I'd take a tested patch that looks sane for both the "warning: this
pcie-pci bridge is dodgy" and for the "try polling, then re-enable for
a while" approach.

                    Linus
