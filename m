Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1GUItY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 04:49:24 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:53057 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1GUItW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 04:49:22 -0400
Date: Thu, 21 Jul 2011 10:49:17 +0200
From: Tejun Heo <tj@kernel.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-ide@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>,
        linux-kernel@vger.kernel.org, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>
Subject: Re: ahci_start_engine compliance with AHCI spec
Message-ID: <20110721084917.GE3455@htj.dyndns.org>
References: <CAN8TOE9CCSiS2koyx=UsZj=9KwaWZW5yDjUUqgJf2=qZU70k1w@mail.gmail.com>
 <20110713131407.GN2872@htj.dyndns.org>
 <CAN8TOE9Rjujf9aLQGONDULNasFiQmVkiUPWUDX=Vf0Nx2pka7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN8TOE9Rjujf9aLQGONDULNasFiQmVkiUPWUDX=Vf0Nx2pka7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jul 18, 2011 at 11:40:17AM -0700, Brian Norris wrote:
> On Wed, Jul 13, 2011 at 6:14 AM, Tejun Heo <tj@kernel.org> wrote:
> > On Fri, Jul 08, 2011 at 04:01:17PM -0700, Brian Norris wrote:
> >> I'm not sure if the "error_handler" and "hard reset" processes are
> >> intended for initialization...as I said I'm a little new!
> >
> > That's how it's supposed to work.  EH is integral part of probing
> > sequence.
> 
> I began to suspect that was the case. It just seemed awkward that the
> expected operation includes a code path named "error".

Heh, well, SCSI called it error_handler but inside ATA I usually call
it exception handler and probing / hot plugging / etc are exceptional
cases compared to boring sending and receiving of bits to already
attached devices. ;)

> >> I have a few other questions:
> >>
> >> What operation could be putting devices in DRQ or BSY states during
> >> initialization but before ahci_start_engine?
> >
> > Hmmm... I have no idea, maybe it has something to do with the first
> > D2H Reg FIS device sends after link gets reset during controller init?
> 
> OK, I'll try to track that one down, but I think that DRQ is set much
> earlier in the initialization than that and won't be cleared until
> between ahci_power_up() and ahci_start_engine() - I tried
> wait-and-poll at several different points in the process to understand
> the HBA/device initialization process.

I see.

> > Hmmm... what happens if you don't comment out ahci_start_engine() call
> > from ahci_start_port()?
> 
> I wasn't commenting out the ahci_start_engine() from
> ahci_start_port(). Can you clarify what you mean?

Oh, I meant "what if you comment out..."  I wrote that sentence in
negative and then switched but forgot removing "don't".

> > Is this the same IP block that Jian Peng was using?
> 
> Yes, it is. I'm taking over some of his work.

Is there any way to detect that particular IP block.  It's the only
one with this problem so maybe we just should treat it specially.

Thanks.

-- 
tejun
