Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab2BNVFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:05:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357Ab2BNVFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:05:23 -0500
Date: Tue, 14 Feb 2012 13:05:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com, vgoyal@redhat.com,
        seiji.aguchi@hds.com
Subject: Re: [PATCH V3] kmsg_dump: Don't run on non-error paths by default
Message-Id: <20120214130522.fdb05b81.akpm@linux-foundation.org>
In-Reply-To: <1328888715-21589-1-git-send-email-mjg@redhat.com>
References: <1328888715-21589-1-git-send-email-mjg@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012 10:45:15 -0500
Matthew Garrett <mjg@redhat.com> wrote:

> Since 04c6862c055fb687c90d9652f32c11a063df15cf kmsg_dump() gets run on
> normal paths including poweroff and reboot. This is less than ideal given
> pstore implementations that can only represent single backtraces, since a
> reboot may overwrite a stored oops before it's been picked up by userspace.
> In addition, some pstore backends may have low performance and provide a
> significant delay in reboot as a result.
> 
> This patch adds a printk.always_kmsg_dump kernel parameter (which can also
> be changed from userspace). Without it, the code will only be run on
> failure paths rather than on normal paths. The option can be enabled in
> environments where there's a desire to attempt to audit whether or not
> a reboot was cleanly requested or not.

So if I'm understanding it correctly, this patch reverts the kernel
behaviour to what it was before 04c6862c055fb687c9 ("kmsg_dump: add
kmsg_dump() calls to the reboot, halt, poweroff and emergency_restart
paths").  The user must now set printk.always_kmsg_dump to get the
04c6862c055fb687c9 behaviour.

Correct?  If so, we should get this into 3.3 so we don't have a oddball
behaviour in one particular kernel release.

