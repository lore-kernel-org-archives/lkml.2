Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab0JSJST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:18:19 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:52333 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab0JSJSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:18:17 -0400
Date: Tue, 19 Oct 2010 10:17:30 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Gleb O. Raiko" <raiko@niisi.msk.ru>
Cc: Kevin Cernekee <cernekee@gmail.com>,
        Shinya Kuribayashi <skuribay@pobox.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, chris@mips.com
Subject: Re: [PATCH resend 5/9] MIPS: sync after cacheflush
Message-ID: <20101019091729.GA31405@linux-mips.org>
References: <17ebecce124618ddf83ec6fe8e526f93@localhost>
 <17d8d27a2356640a4359f1a7dcbb3b42@localhost>
 <4CBC4F4E.5010305@pobox.com>
 <20101018191936.GH27377@linux-mips.org>
 <AANLkTimmatKpOFATCPDxthN-9pZzzXRAOnLGR1_348=r@mail.gmail.com>
 <4CBD5CC9.8070706@niisi.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBD5CC9.8070706@niisi.msk.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 12:54:33PM +0400, Gleb O. Raiko wrote:

> On 18.10.2010 23:41, Kevin Cernekee wrote:
> >I have not been able to find any official statement from MIPS that
> >says that CACHE + SYNC should be used, but that seems like the most
> >intuitive way to implement things on the hardware side.
> 
> Indeed, both Architecture for Programmers in Vol. 2 describing
> instruction sets not so clearly say that sync is needed after cache.
> For example, documents with rev. 2.62, p. 92 (for MIPS32 ISA) or p.
> 96 (for MIPS64).

The MIPS32 BIS v2.6 spec says on page 92:

  "The CACHE instruction and the memory transactions which are sourced by
   the CACHE instruction, such as cache refill or cache writeback, obey
   the ordering and completion rules of the SYNC instruction."

That's not as clearly spelt out as one would like but it seems to imply
that only reads/writes preceeding the CACHE instruction are guaranteed
to have completed that is the last CACHE instruction that was executed
may still be incomplete.

> Considering whether just sync enough I'd like to note some boxes may
> implement dma master and slave blocks to be unsynchronized.
> Also,there may be write buffers somewhere in the path between cpu,
> memory, and even a dma master.
> 
> BTW, we have plat_extra_sync_for_device which has appropriate name
> but invented to do things before cache flush. :-) It seems we need
> another one which will do something after.

  Ralf
