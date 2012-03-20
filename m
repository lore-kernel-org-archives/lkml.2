Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2CTR5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 13:57:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45224 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2CTR5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 13:57:43 -0400
MIME-Version: 1.0
In-Reply-To: <1330588483-30957-1-git-send-email-andrey.warkentin@gmail.com>
References: <1330588483-30957-1-git-send-email-andrey.warkentin@gmail.com>
Date: Tue, 20 Mar 2012 13:57:41 -0400
Message-ID: <CANz0V+5ayWh3-xR1i4nCqTGF+6x+f7mOeokEhCCXhvG3a3pFhw@mail.gmail.com>
Subject: Re: [PATCH] x86 NMI: Be smarter about invoking panic() inside NMI handler.
From: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, jason.wessel@windriver.com,
        Andrei Warkentin <andrey.warkentin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012/3/1 Andrei Warkentin <andrey.warkentin@gmail.com>:
> If two (or more) unknown NMIs arrive on different CPUs, there
> is a large chance both CPUs will wind up inside panic(). This
> is fine, unless you want to enter KDB - KDB cannot round up
> all CPUs, because some of them are stuck inside
> panic_smp_self_stop with NMI latched. This is
> easy to replicate with QEMU. Boot with -smp 4 and
> send NMI using the monitor.
>
> Solution for this - attempt to enter panic() from NMI
> handler. If panic() is already active in the system,
> just exit out of the NMI handler. This lets KDB round
> up CPUs.
>
> Signed-off-by: Andrei Warkentin <andrey.warkentin@gmail.com>
> ---

Any feedback on this? Who are the right maintainers to bug about this?

A
