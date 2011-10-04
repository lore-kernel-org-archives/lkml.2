Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab1JDREd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:04:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63428 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab1JDREc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:04:32 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwc-KQSZfciq87nXgGXvXwx95z1HSVKVprc=tajJOd20g@mail.gmail.com>
References: <alpine.DEB.2.00.1110041731390.29734@skynet.skynet.ie>
	<CA+55aFwc-KQSZfciq87nXgGXvXwx95z1HSVKVprc=tajJOd20g@mail.gmail.com>
Date: Tue, 4 Oct 2011 13:04:31 -0400
Message-ID: <CADnq5_NL2t8BBhybkqf+s=6z3gBAPUpmvgWjkMabCsgb9YpjGA@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Alex Deucher <alexdeucher@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 4, 2011 at 12:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Oct 4, 2011 at 9:34 AM, Dave Airlie <airlied@linux.ie> wrote:
>>
>> all radeon fixes, one nasty startup crash and/or memory corruption on one
>> family of radeon hd6450s resulted in a patch to stop setting a bunch of
>> regs in the drivers and let the BIOS set them correctly, displayport
>> regression fix, and some off-by-one in the cursor code around the corners
>> of the screens.
>
> Has this been tested with suspend/resume on a lot of machines?
>
> In general, the registers that get set on boot correctly absolutely do
> *not* get set on resume.
>
> So the registers that you now no longer set at boot-time should almost
> certainly still be saved and restored across suspend/resume. I don't
> know the code well enough to read the diffs, but a quick grep seems to
> show that when you removed the boot-time setup, you also removed the
> resume-time setup (well, at least MC_SHARED_CHREMAP doesn't seem to be
> used anywhere any more: it may be that it's saved-restores in some
> kind of "loop over all registers" that wouldn't have triggered the
> grep).
>
> I pulled, but please verify that whole thing.

It's safe.  The hw default value is fine (value in the register at
asic power up).  On most cards the hw default value is is fine.  If it
needs to be overridden in certain cases, that's handled by the
asic_init vbios table which is executed at boot by the vbios and by
the driver at resume time.

Alex
