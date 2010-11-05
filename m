Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0KETe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 15:34:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533Ab0KETe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 15:34:26 -0400
Date: Fri, 5 Nov 2010 12:34:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: hmh@hmh.eng.br, alan@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sysfs: device-core: open - close notifier
Message-Id: <20101105123407.44105afc.akpm@linux-foundation.org>
In-Reply-To: <1288958986-26511-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1288958986-26511-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Nov 2010 14:09:46 +0200
Samu Onkalo <samu.p.onkalo@nokia.com> wrote:

> Device drivers have no idea when somebody in userspace keeps some sysfs entry
> open. The driver just receives read or write calls. The driver may want to
> control HW state based on activity so it either have to turn HW on and off
> for each sysfs access or it needs separate enable disable entry which controls
> the HW state. In cases where sysfs is used to pass some events under interrupt
> control (like proximity events from the proximity sensors) it is not enough to
> just keep sysfs entry open in userspace.

I'm unconvinced that drivers should be doing this and it could be that
once this proposal is fully understood, the verdict is "stop doing
that".  But we aren't there yet.

So please, tell us in much more detail why you believe that this form
of sysfs/device interaction is desirable.  Probably, describing the
specific example of proximity drivers would be a good way of doing this.

> This patch adds a possibility for driver to know when some sysfs entry is
> open.

The implementation itself doesn't appear to cope with multiple opens at
all.  What happens if userspace does open, open, close?  The drive has to
do its own refcounting, duplicating the VFS core's refcounting (which
might be hard to use for this purpose).

Stylistically, the use of a combined open+close handler with a mode
argument is unusual.  Separate ->open and ->close notifiers would be
more usual.

