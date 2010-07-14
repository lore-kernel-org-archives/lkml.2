Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0GNLyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 07:54:11 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57306 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185Ab0GNLyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:54:10 -0400
Subject: Re: kmemleak, cpu usage jump out of nowhere
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zeno Davatz <zdavatz@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTilBdReJssNYLAx6sHtPTez57keWJl6QDOu5V986@mail.gmail.com>
References: <AANLkTil6opQmTVVxuP1ngz72_ijpLzdlSFWDSyi4whOt@mail.gmail.com>
	 <tnx630ibd2q.fsf@e102109-lin.cambridge.arm.com>
	 <AANLkTilBdReJssNYLAx6sHtPTez57keWJl6QDOu5V986@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 14 Jul 2010 12:54:03 +0100
Message-ID: <1279108443.8592.75.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2010 11:54:03.0611 (UTC) FILETIME=[4159BAB0:01CB234B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 11:04 +0100, Zeno Davatz wrote:
> On Wed, Jul 14, 2010 at 11:57 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > Zeno Davatz <zdavatz@gmail.com> wrote:
> >> Sometimes in the middle of nowhere all of a sudden all of my 8-cores
> >> are at 100% CPU usage and my machine really lags and hangs and is not
> >> useable anymore. Some random process just grabs a bunch CPUs according
> >> to htop.
> >
> > These may be related to the NO_BOOTMEM configuration (I sent a patch in
> > a separate reply).
> >
> > But even when kmemleak scans the memory, it only uses a single thread
> > and you should only see a single CPU going to 100%. I don't think
> > kmemleak scanning can explain why all the 8 cores are going up to 100%.
> 
> I am doing:
> 
> /usr/src/my2.6> sudo patch -p1 < patch_catalin
> patching file mm/bootmem.c
> Hunk #1 FAILED at 435.
> Hunk #2 FAILED at 461.
> 2 out of 2 hunks FAILED -- saving rejects to file mm/bootmem.c.rej
> patching file mm/page_alloc.c
> Hunk #1 FAILED at 3659.
> 1 out of 1 hunk FAILED -- saving rejects to file mm/page_alloc.c.rej
> 
> Any hints why it wont apply? Will this patch be in the next RC?

The patch is against 2.6.35-rc4. I'll send it to Linus and hopefully it
will get merged during rc.

BTW, you can disable kmemleak scanning by doing:

# echo scan=off > /sys/kernel/debug/kmemleak

Do you still get that high CPU usage?

-- 
Catalin

