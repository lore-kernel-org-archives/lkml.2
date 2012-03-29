Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab2C2HUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 03:20:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34976 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758801Ab2C2HT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 03:19:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120327160601.GA19273@redhat.com>
References: <1330588483-30957-1-git-send-email-andrey.warkentin@gmail.com>
	<CANz0V+5ayWh3-xR1i4nCqTGF+6x+f7mOeokEhCCXhvG3a3pFhw@mail.gmail.com>
	<20120327160601.GA19273@redhat.com>
Date: Thu, 29 Mar 2012 03:19:56 -0400
Message-ID: <CANz0V+7J=gN1_cH2jCnCSdQ=TnL9=2+S+6orBPPep=-tFN4p0A@mail.gmail.com>
Subject: Re: [PATCH] x86 NMI: Be smarter about invoking panic() inside NMI handler.
From: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        jason.wessel@windriver.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

Thank you for your feedback!

2012/3/27 Don Zickus <dzickus@redhat.com>:
>
> Hmm, if try_panic fails, then the cpu continues on executing code.  This
> might further corrupt an already broken system.  So I don't think this
> patch will work as is.
>

I see what you are saying. I could make the argument that this kind
of system corruption could occur anyway even if you did panic inside
an IRQ context instead, but I would tend to agree that your proposed
solution is much better than adding another panic interface.

> Perhaps instead of panic'ing in the NMI context, we use irq_work and panic
> in an interrupt context instead.  We still get the system to stop (though
> it might still execute some interrupts) and it will be out of the NMI
> context.
>
> However, you will still run into a similar problem when in the
> panic/reboot case we shutdown all the remote cpus and have them sitting in
> a similar cpu_relax loop in the NMI context, while the panic'ing cpu
> cleans things up.
>

Sorry, could you clarify what you mean? How does this affect KDB usage?

A
