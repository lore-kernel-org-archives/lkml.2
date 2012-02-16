Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2BPWwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:52:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab2BPWwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:52:21 -0500
Date: Thu, 16 Feb 2012 14:52:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH v5 00/27] irq_domain generalization and rework
Message-Id: <20120216145219.0f1c1b98.akpm@linux-foundation.org>
In-Reply-To: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012 02:09:01 -0700
Grant Likely <grant.likely@secretlab.ca> wrote:

> 
> This series generalizes the "irq_host" infrastructure from powerpc
> so that it can be used by all architectures and renames it to "irq_domain".

drivers/mfd/twl-core.c is fairly horked on i386 allmodconfig:

drivers/mfd/twl-core.c: In function 'twl_probe':
drivers/mfd/twl-core.c:1218: error: implicit declaration of function 'irq_alloc_descs'
drivers/mfd/twl-core.c:1226: error: implicit declaration of function 'irq_domain_add_legacy'
drivers/mfd/twl-core.c:1227: error: 'irq_domain_simple_ops' undeclared (first use in this function)
drivers/mfd/twl-core.c:1227: error: (Each undeclared identifier is reported only once
drivers/mfd/twl-core.c:1227: error: for each function it appears in.)


This is today's linux-next so it has rmk's "ARM: omap: fix broken
twl-core dependencies and ifdefs" in there, which looks like it
attempts to repair this stuff.

It's looking for things which are in both linux/irq.h and in
linux/irqdomain.h.



btw, Russell, regarding this comment in include/linux/irq.h:

/*
 * Please do not include this file in generic code.  There is currently
 * no requirement for any architecture to implement anything held
 * within this file.
 *
 * Thanks. --rmk
 */

A quick grep indicates that we've lost this battle ;) Is the comments
still true?  Should we stop discouraging inclusion of linux/irq.h? 
Does anyone even know that it's discouraged ;)



