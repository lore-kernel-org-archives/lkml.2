Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab2FVVM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:12:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab2FVVMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:12:55 -0400
Date: Fri, 22 Jun 2012 14:12:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Chris Friesen <chris.friesen@genband.com>
Subject: Re: [PATCH v2 1/2] msync: support syncing a small part of the file
Message-Id: <20120622141253.1e9747cf.akpm@linux-foundation.org>
In-Reply-To: <1339773179-31210-2-git-send-email-pbonzini@redhat.com>
References: <1339773179-31210-1-git-send-email-pbonzini@redhat.com>
	<1339773179-31210-2-git-send-email-pbonzini@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012 17:12:58 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> msync does not need to flush changes to the entire file, even with MS_SYNC.
> Instead, it can use vfs_fsync_range to only synchronize a part of the file.
> This is part of the specification; expecting msync to synchronize all the
> file would take a very creative interpretation of the manual page as well
> as the specification.
> 
> In addition, not all metadata has to be synced; msync is closer to
> fdatasync than it is to fsync.  So, pass 1 to vfs_fsync_range.

I renamed the patch to "msync: switch to syncing only the affected part
of the file" to emphasise that there is a behavioural change here.

Then I deleted the patch.

Please recall my thus-far-utterly-and-irritatingly-ignored comments
about nonlinear mappings.  Presently an msync() on a nonlinear mapping
will work correctly, because we sync the whole file, yes?  And with
this change, we will no longer sync all the pages which were covered by
the affected memory range.  Thus breaking the syscall?
