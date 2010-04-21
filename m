Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0DUTMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 15:12:20 -0400
Received: from relay2.sgi.com ([192.48.179.30]:49496 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754518Ab0DUTMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:12:16 -0400
Date: Wed, 21 Apr 2010 20:12:13 +0100
From: Hedi Berriche <hedi@sgi.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
	pid_max v2
Message-ID: <20100421191213.GR16427@zorg.emea.sgi.com>
References: <4BCE579C.5070100@sgi.com> <4BCE5A73.3000904@sgi.com> <20100421102350.4c222e6b@lxorguk.ukuu.org.uk> <20100421165934.GN16427@zorg.emea.sgi.com> <20100421185852.3397f1da@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421185852.3397f1da@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 18:54 Alan Cox wrote:
| Hedi Berriche <hedi@sgi.com> wrote:
|
| > I just checked on an *idle* 1664 CPUs system and I can see 26844 tasks, all
| > but few being kernel threads.
| 
| So why have we got 26844 tasks. Isn't that a rather more relevant
| question.

OK, here's a rough breakdown of the tasks

     104 kswapd
    1664 aio
    1664 ata
    1664 crypto
    1664 events
    1664 ib_cm
    1664 kintegrityd
    1664 kondemand
    1664 ksoftirqd
    1664 kstop
    1664 migration
    1664 rpciod
    1664 scsi_tgtd
    1664 xfsconvertd
    1664 xfsdatad
    1664 xfslogd

that's 25064, omitting the rest as its contribution to the overall total is
negligible.

[[

Let's also not forget all those ephemeral user space tasks (udev and the likes)
that will be spawned at boot time on even large systems with even more
thousands of disks, arguably one might consider hack initrd and similar to work
around the problem and set pid_max as soon as /proc becomes available but it's
a bit of a PITA.

]]

| And as I asked before - how does Tejun's work on sanitizing work queues
| affect this ?

I'm not familiar with the work in question so I (we) will have to look it up,
and at it and see whether it's relevant to what we're seeing here. It does sound
like it might help, to certain extent at least.

That said, while I am genuinely interested in spending time on this and digging
further to see whether something has/can be done about keeping under control the
number of tasks required to comfortably boot a system of this size, I think that
in the meantime the boot parameter approach is useful in the sense that it addresses
the immediate problem of being able such systems *without* any risk to break the
code or alter the default behaviour.

Cheers,
Hedi.
-- 
Be careful of reading health books, you might die of a misprint.
	-- Mark Twain
