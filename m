Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0FGVAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:00:00 -0400
Received: from 64-131-60-146.usfamily.net ([64.131.60.146]:43927 "EHLO
	mail.sandeen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab0FGU77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 16:59:59 -0400
Message-ID: <4C0D5DCD.5010201@sandeen.net>
Date: Mon, 07 Jun 2010 15:59:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Jeffrey Merkey <jeffmerkey@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: EXT3 File System Corruption 2.6.34
References: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com>
In-Reply-To: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeffrey Merkey wrote:
> Still seeing file system corruption after journal recovery in EXT3.
> It's easy to reproduce, though the symptoms vary.  One way is to
> rebuild a program and while the program is being compiled just shut
> off power to the system by pulling the plug.  I am seeing the
> /root/.viminfo file trashed after recovery if Vim was active during
> poweroff.  I am also seeing object modules getting built which the LD
> linker claims are "invalid" following a recovery event.  I suspect a
> bug in the buffer cache since deleting the file still causes the old
> data to be returned from buffer cache even when the sectors are
> overwritten, but both are interrelated.  Seems in some way related to
> EXT3 recovery which results in the buffer cache returning old sectors
> and junk.
> 
> Not hard to reproduce, but the symptoms are always a little different
> but the /root/.viminfo file getting nuked seems a common affect of
> this bug.

"file system corruption" usually means corrupted metadata, but I guess
here you mean file corruption, i.e. corrupted data.

If you have buffered data in the cache, it will be lost when you pull
the plug.  If your userspace doesn't sync it, this is expected.  But it's
not clear to me what you're seeing.

I'm also not clear on what you mean about deleting the file and having old
data returned.  Maybe a little cut and paste from the screen would help
explain what you see.

I'd also check CONFIG_EXT3_DEFAULTS_TO_ORDERED and be sure you're
using data=ordered mode by default.

-Eric

> Jeff

