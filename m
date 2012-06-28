Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab2F1WWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 18:22:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57154 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2F1WWf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 18:22:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
References: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
Date: Thu, 28 Jun 2012 15:22:34 -0700
X-Google-Sender-Auth: E9sPelkSlxbdKy92zaRpMhzQnRo
Message-ID: <CAA9_cmejubhZRXkUc_-FYhgD3B0sjR8p4YO3VkgcxWvisd-RWg@mail.gmail.com>
Subject: Re: [set5 PATCH 0/6] scsi, async: asynchronous probing rework / fixes
From: Dan Williams <dan.j.williams@intel.com>
To: JBottomley@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 11:46 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Set5 of 5 patchsets to update scsi, libsas, and libata in
> support of the isci driver.
>
> Commit 43a8d39d "[SCSI] fix async probe regression" found that
> async_synchronize_full() was missing async work that was scheduled to
> its own domain.  This led James to note:
>
>      "My theory is that this is an init problem: The assumption in a lot of
>       our code is that async_synchronize_full() waits for everything ... even
>       the domain specific async schedules, which isn't true."
>
> ...and this set aims to make that assumption true, but also with the
> ability to opt-out for "private" async work.
>
> The other async probe fix is in the area of unplug events that occur in
> the scsi async scanning interval.  Essentially scsi_remove_target() can
> now see semi-initialized scsi_targets that have yet to be added via
> device_add().
>
> If there are no objections I'll put these in -next.  But I expect at
> least patch1 and patch2 will need an ack from Arjan before the set shows
> up in scsi.git.
>
> ---

James,

I caught a couple conflicts with scsi.git/for-next and was able to fix
them up without rebasing on top of your tree.  I'll resend the series
after letting these sit in -next for a while, or I can prepare a tag
for you to pull with the whole pending set.

>
> Dan Williams (6):
>      async: introduce 'async_domain' type

dropped the include of async.h

>      async: make async_synchronize_full() flush all work regardless of domain
>      scsi: queue async scan work to an async_schedule domain
>      scsi: cleanup usages of scsi_complete_async_scans

dropped the changes to scsi_wait_scan.c since that file is deleted in
your for-next branch.

--
Dan
