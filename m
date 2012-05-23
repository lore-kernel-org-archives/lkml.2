Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088Ab2EWUhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:37:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48641 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758666Ab2EWUha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:37:30 -0400
Date: Wed, 23 May 2012 16:37:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kernel development list <linux-kernel@vger.kernel.org>
cc: Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Greg KH <greg@kroah.com>
Subject: Excessive latency for dev_dbg?
Message-ID: <Pine.LNX.4.44L0.1205231627140.1248-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just tried doing some testing of 3.4.  Sequences of literally
adjacent dev_dbg() calls -- with local interrupts disabled -- show up
in the log buffer spaced at time intervals between 1 and 4
milliseconds!

This is with CONFIG_DYNAMIC_DEBUG not enabled, and CONFIG_PRINTK_TIME,
CONFIG_PREEMPT, CONFIG_HIGH_RES_TIMERS, and CONFIG_HPET_TIMER all set
to y.

What's going on here?  Did printk suddenly slow down a lot?  Or has the
timer code gone crazy?

Alan Stern

