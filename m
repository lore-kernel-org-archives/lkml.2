Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab0J1IdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 04:33:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63995 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933065Ab0J1IdQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 04:33:16 -0400
Subject: Re: kmemleak disabled itself in 2.6.36
From: Catalin Marinas <catalin.marinas@arm.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <201010272112.59520.toralf.foerster@gmx.de>
References: <201010272112.59520.toralf.foerster@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 28 Oct 2010 09:33:09 +0100
Message-ID: <1288254789.10238.5.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 28 Oct 2010 08:33:09.0403 (UTC) FILETIME=[C0450EB0:01CB767A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 20:12 +0100, Toralf Förster wrote:
> I'm unsure whether this happens due to a
> $> sudo su -c "echo clear > /sys/kernel/debug/kmemleak"
> or while regular scanning, but anyway seems not to be normal, or ?
> 
> 2010-10-27T20:42:21.697+02:00 n22 kernel: flush-254:0: page allocation failure. order:0, mode:0x0
[...]
> 2010-10-27T20:42:21.699+02:00 n22 kernel: kmemleak: Cannot allocate a kmemleak_object structure
> 2010-10-27T20:42:21.699+02:00 n22 kernel: Pid: 15475, comm: flush-254:0 Not tainted 2.6.36 #2
[...]
> 2010-10-27T20:42:21.700+02:00 n22 kernel: kmemleak: Kernel memory leak detector disabled

Are you running out of memory on your system? Kmemleak tried to allocate
a structure but the slab allocator failed to get page. Kmemleak disables
itself in such situations but the problem is somewhere else (not enough
memory?).

Catalin

