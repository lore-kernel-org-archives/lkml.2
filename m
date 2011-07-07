Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab1GGUBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 16:01:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751842Ab1GGUBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 16:01:40 -0400
Date: Thu, 7 Jul 2011 13:01:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergiu Iordache <sergiu@chromium.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] char drivers: ramoops debugfs entry
Message-Id: <20110707130130.8dd02f01.akpm@linux-foundation.org>
In-Reply-To: <1309994990-4729-4-git-send-email-sergiu@chromium.org>
References: <1309994990-4729-1-git-send-email-sergiu@chromium.org>
	<1309994990-4729-4-git-send-email-sergiu@chromium.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Jul 2011 16:29:50 -0700
Sergiu Iordache <sergiu@chromium.org> wrote:

> While ramoops writes to ram, accessing the dump requires using /dev/mem
> and knowing the memory location (or a similar solution). This patch
> provides a debugfs interface through which the respective memory
> area can be easily accessed.
> 
> The entry added is /sys/kernel/debug/ramoops/next
> 
> The entry returns a dump of size record_size each time, skipping invalid
> dumps. When it reaches the end of the memory area reserved for dumps it
> returns an empty record and resets the current record count.

The patch increases the size of ramoops.o text&data from 1725 bytes to
2282 even when CONFIG_DEBUG_FS=n.  That's quite a lot of bloat!

Furthermore, I think debugfs is the wrong place to put this.  debugfs
is, umm, for debugging.  It's a place in which to put transitory junk
which may or may not be there and where interfaces may change without
notice and whose presence userspace should not assume.  But in this
patch you're proposing a permanent and formal new interface into the
ramoops driver.  It should go into a permanent well-known place where
it will be maintained with the formality and care of all the other
parts of the kernel API.

Also, you're proposing a new kernel/userspace API but it wasn't
documented anywhere.  We don't want to have to reverse-engineer your
proposed API from the implementation for review purposes.  That API
should have been exhaustively documented in the changelog so others can
decide whether they like it.

Finally, we should provide user documentation for the new interface so
others can find out that it exists and can use it correctly.  We seem
not to have bothered documenting ramoops so we don't currently have a
context in which to do this.
