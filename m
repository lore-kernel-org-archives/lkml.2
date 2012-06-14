Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab2FNMY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 08:24:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63621 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2FNMYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 08:24:55 -0400
Message-ID: <4FD9D813.1010203@redhat.com>
Date: Thu, 14 Jun 2012 14:24:51 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 2/2] msync: start async writeout when MS_ASYNC
References: <1338497035-13014-1-git-send-email-pbonzini@redhat.com> <1338497035-13014-3-git-send-email-pbonzini@redhat.com> <20120613142949.734818a8.akpm@linux-foundation.org>
In-Reply-To: <20120613142949.734818a8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/06/2012 23:29, Andrew Morton ha scritto:
> Also, it hardwires into the kernel behaviour which userspace itself
> could have initiated, with sync_file_range().  ie: reduced flexibility.

Actually sync_file_range calls filemap_fdatawrite_range with
WB_SYNC_ALL, hence it does the writeout synchronously and can block for
an extended period of time.  Hence sync_file_range is more similar to
MS_SYNC except without the metadata write.

Instead, this patch uses WB_SYNC_NONE, while still using tag-and-write
to avoid livelock.

I'll wait a day or two to let others voice their opinions, and then send
a fixed v2 with updated commit messages from this discussion.

Paolo
