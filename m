Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab2B2LDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 06:03:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48151 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2B2LDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 06:03:18 -0500
Message-ID: <1330513384.11248.129.camel@twins>
Subject: Re: RFC [PATCH] SMP: Don't schedule tasks on inactive cpu(s)
From: Peter Zijlstra <peterz@infradead.org>
To: Jonas Aaberg <jonas.aberg@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 29 Feb 2012 12:03:04 +0100
In-Reply-To: <1330512150-20727-1-git-send-email-jonas.aberg@stericsson.com>
References: <1330512150-20727-1-git-send-email-jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 11:42 +0100, Jonas Aaberg wrote:
> This patch removes the ability to schedule tasks on cpus that are online,
> but not active.  The reason for this patch is that during cpu hotplug
> on ARM (atleast) there is a short window where cpuX (X > 0) is online, but
> busy-waiting on cpu0 to put it active, meanwhile cpu0 can be interrupted
> and try to schedule something on the cpu that is busy checking its active bit.

https://lkml.org/lkml/2011/12/15/255

that one?

I _think_ its correct, but it would be so good if someone else could
verify.
