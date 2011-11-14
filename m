Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab1KNXzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:55:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50806 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab1KNXzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:55:20 -0500
MIME-Version: 1.0
In-Reply-To: <1321312358-11234-1-git-send-email-keescook@chromium.org>
References: <1321312358-11234-1-git-send-email-keescook@chromium.org>
Date: Mon, 14 Nov 2011 15:55:20 -0800
Message-ID: <CA+8MBb+z2ChjVYfBQ_2m2PvtQicYYv9FCa5ZFnGH2j1UvE-sdg@mail.gmail.com>
Subject: Re: [PATCH 0/3] pstore: pass allocated memory region back to caller
From: Tony Luck <tony.luck@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 3:12 PM, Kees Cook <keescook@chromium.org> wrote:
> Since pstore's buf_lock cannot be held while doing the VFS population,
> these patches make it the backend's responsibility to pass up an allocated
> buffer instead during reads.

The split into three parts is good for review purposes - but I'll
squish them all together
into one commit to avoid breaking bisectability.

I'm trying to work out whether I should be worried about the removal
of the locks
around the:

   (*open)(...)
   while (size = (*read)(...)) {
   }
   (*close)()

section in pstore_get_records().  If someone tries to simultaneously mount
pstore in multiple places - will the upper level mount code serialize? I don't
think the backends will be happy if multiple callers execute that at the same
time.

-Tony
