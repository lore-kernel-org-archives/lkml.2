Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab0JJUSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 16:18:12 -0400
Received: from netrider.rowland.org ([192.131.102.5]:48850 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751294Ab0JJUSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 16:18:09 -0400
Date: Sun, 10 Oct 2010 16:18:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: PATCH: PM / Runtime: Remove idle notification after failing
 suspend (was: Re: [linux-pm] [PATCH] PM: add synchronous ...)
In-Reply-To: <201010090124.56493.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1010101616410.30042-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Oct 2010, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Runtime: Remove idle notification after failing suspend
> 
> If runtime suspend of a device fails returning -EAGAIN or -EBUSY,
> which means that it's safe to try to suspend it again, the PM core
> runs the runtime idle helper function for it.  Unfortunately this may
> lead to problems, for example for PCI devices whose drivers don't
> implement the ->runtime_idle() callback, because in that case the
> PCI bus type's ->runtime_idle() always calls pm_runtime_suspend()
> for the given device.  Thus, if it is automatically called by a
> driver's ->runtime_suspend() returning -EAGAIN or -EBUSY, it will
> cause the suspend to happen again possibly causing a busy loop to
> appear.  To avoid that, remove the idle notification after failing
> runtime suspend of a device altogether and let the callers of
> pm_runtime_suspend() repeat the operation if need be.
> 
> Reported-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

This is fine as far as I'm concerned.

Alan Stern

