Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab0K1PfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 10:35:10 -0500
Received: from netrider.rowland.org ([192.131.102.5]:53068 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753229Ab0K1PfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 10:35:07 -0500
Date: Sun, 28 Nov 2010 10:35:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM: Prevent dpm_prepare() from returning errors
 unnecessarily
In-Reply-To: <201011281312.49949.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1011281031240.27303-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Nov 2010, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Currently dpm_prepare() returns error code if it finds that a device
> being suspended has a pending runtime resume request.  However, it
> should not do that if the checking for wakeup events is not enabled.

It doesn't.  The line you changed _does_ check device_may_wakeup().

> On the other hand, if the checking for wakeup events is enabled, it
> can return error when a wakeup event is detected, regardless of its
> source.

Will adding this call to pm_wakeup_event() end up double-counting some 
events?

Alan Stern

