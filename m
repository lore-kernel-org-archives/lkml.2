Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab1JDQ7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:59:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38326 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab1JDQ7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:59:14 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110041731390.29734@skynet.skynet.ie>
References: <alpine.DEB.2.00.1110041731390.29734@skynet.skynet.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 4 Oct 2011 09:58:53 -0700
X-Google-Sender-Auth: 0wauSRzPvICSvOE6kaTvibRe6xc
Message-ID: <CA+55aFwc-KQSZfciq87nXgGXvXwx95z1HSVKVprc=tajJOd20g@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Dave Airlie <airlied@linux.ie>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 4, 2011 at 9:34 AM, Dave Airlie <airlied@linux.ie> wrote:
>
> all radeon fixes, one nasty startup crash and/or memory corruption on one
> family of radeon hd6450s resulted in a patch to stop setting a bunch of
> regs in the drivers and let the BIOS set them correctly, displayport
> regression fix, and some off-by-one in the cursor code around the corners
> of the screens.

Has this been tested with suspend/resume on a lot of machines?

In general, the registers that get set on boot correctly absolutely do
*not* get set on resume.

So the registers that you now no longer set at boot-time should almost
certainly still be saved and restored across suspend/resume. I don't
know the code well enough to read the diffs, but a quick grep seems to
show that when you removed the boot-time setup, you also removed the
resume-time setup (well, at least MC_SHARED_CHREMAP doesn't seem to be
used anywhere any more: it may be that it's saved-restores in some
kind of "loop over all registers" that wouldn't have triggered the
grep).

I pulled, but please verify that whole thing.

                              Linus
