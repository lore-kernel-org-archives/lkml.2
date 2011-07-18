Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1GRSkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 14:40:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39861 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1GRSkT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 14:40:19 -0400
MIME-Version: 1.0
In-Reply-To: <20110713131407.GN2872@htj.dyndns.org>
References: <CAN8TOE9CCSiS2koyx=UsZj=9KwaWZW5yDjUUqgJf2=qZU70k1w@mail.gmail.com>
	<20110713131407.GN2872@htj.dyndns.org>
Date: Mon, 18 Jul 2011 11:40:17 -0700
Message-ID: <CAN8TOE9Rjujf9aLQGONDULNasFiQmVkiUPWUDX=Vf0Nx2pka7w@mail.gmail.com>
Subject: Re: ahci_start_engine compliance with AHCI spec
From: Brian Norris <computersforpeace@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>,
        linux-kernel@vger.kernel.org, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Wed, Jul 13, 2011 at 6:14 AM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Jul 08, 2011 at 04:01:17PM -0700, Brian Norris wrote:
>> I'm not sure if the "error_handler" and "hard reset" processes are
>> intended for initialization...as I said I'm a little new!
>
> That's how it's supposed to work.  EH is integral part of probing
> sequence.

I began to suspect that was the case. It just seemed awkward that the
expected operation includes a code path named "error".

>> I have a few other questions:
>>
>> What operation could be putting devices in DRQ or BSY states during
>> initialization but before ahci_start_engine?
>
> Hmmm... I have no idea, maybe it has something to do with the first
> D2H Reg FIS device sends after link gets reset during controller init?

OK, I'll try to track that one down, but I think that DRQ is set much
earlier in the initialization than that and won't be cleared until
between ahci_power_up() and ahci_start_engine() - I tried
wait-and-poll at several different points in the process to understand
the HBA/device initialization process.

> Hmmm... what happens if you don't comment out ahci_start_engine() call
> from ahci_start_port()?

I wasn't commenting out the ahci_start_engine() from
ahci_start_port(). Can you clarify what you mean?

> Is this the same IP block that Jian Peng was using?

Yes, it is. I'm taking over some of his work.

Thanks for the responses.

Brian
