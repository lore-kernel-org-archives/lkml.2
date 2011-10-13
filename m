Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab1JMIn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:43:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47805 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1JMInZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:43:25 -0400
MIME-Version: 1.0
In-Reply-To: <201110131025.24950.philipp.reisner@linbit.com>
References: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
	<1318422455-17539-14-git-send-email-philipp.reisner@linbit.com>
	<CAMuHMdXGCEUGanrsyFkgyr3ZAr5YpgrjbVqJtvCu5Li6XMMDMA@mail.gmail.com>
	<201110131025.24950.philipp.reisner@linbit.com>
Date: Thu, 13 Oct 2011 10:43:24 +0200
X-Google-Sender-Auth: pONF9Dhks-rdBL-pZ_epMFt7A-0
Message-ID: <CAMuHMdXesV96Q-XUNkTRWN9aVyk3oH1HGgn+0p_4A3EtyqG2mQ@mail.gmail.com>
Subject: Re: [Drbd-dev] [PATCH 13/13] DRBD: Fix comparison always false
 warning due to long/long long compare
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: drbd-dev@lists.linbit.com, David Howells <dhowells@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 10:25, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> Am Mittwoch, 12. Oktober 2011, 15:35:28 schrieb Geert Uytterhoeven:
>> On Wed, Oct 12, 2011 at 14:27, Philipp Reisner
>> <philipp.reisner@linbit.com> wrote:
>> > From: David Howells <dhowells@redhat.com>
>> >
>> > Fix warnings of the following nature in the drbd header:
>> >
>> > In file included from drivers/block/drbd/drbd_bitmap.c:32:
>> > drivers/block/drbd/drbd_int.h: In function 'drbd_get_syncer_progress':
>> > drivers/block/drbd/drbd_int.h:2234: warning: comparison is always false
>> > due to limited range of data
>> >
>> > where mdev->rs_total (an unsigned long) is being compared to 1ULL << 32,
>> > which is always false on a 32-bit machine.
>>
>> But on 32-bit, unsigned long is never larger than UINT_MAX neither, so
>> it doesn't
>> really change anything??
>
> As the commit message says, David's intention was to silence a compiler
> warning, not to change anything.

Sure, but
  1) Is the comparison a bug on 32-bit?
  2) I don't see a reason why (a different version of) gcc won't give
a warning for the
      new comparison always being false.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
