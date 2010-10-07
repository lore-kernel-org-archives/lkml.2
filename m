Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab0JGVSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:18:10 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:33508 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239Ab0JGVSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:18:08 -0400
Date: Thu, 7 Oct 2010 14:20:03 -0700
From: Andres Salomon <dilinger@queued.net>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OLPC: Add XO-1 poweroff support
Message-ID: <20101007142003.68b6ad7e@debxo>
In-Reply-To: <AANLkTind-S=vzba56DmkzR2BixLGUyBTqu4rgaMcSf5w@mail.gmail.com>
References: <20101007185952.A36859D401B@zog.reactivated.net>
	<20101007130904.29350df2@debxo>
	<AANLkTind-S=vzba56DmkzR2BixLGUyBTqu4rgaMcSf5w@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010 21:42:59 +0100
Daniel Drake <dsd@laptop.org> wrote:

> On 7 October 2010 21:09, Andres Salomon <dilinger@queued.net> wrote:
> > Any particular reason why this can't be modular?
> 
> Because of the pm_power_off thing.
> Also, a similar situation would be encountered with set_suspend_ops().
> 
> I don't really understand your suggestion. If we set it to NULL on
> module unload then the power off would crash on shutdown, right?
> 
> Daniel


See arch/x86/kernel/apm_32.c for an example of modular pm_power_off
handling.

Power off shouldn't crash; at least, native_machine_power_off first
check if pm_power_off is !NULL before calling it.
