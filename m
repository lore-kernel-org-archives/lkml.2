Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab0GZGUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 02:20:06 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52209 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443Ab0GZGUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 02:20:04 -0400
X-Sasl-enc: ZxAprgNAnIfqWGM2vtBZj8zo7wjmOuTfw0MWINg6KfTT 1280125203
Message-ID: <4C4D2913.8020200@ladisch.de>
Date: Mon, 26 Jul 2010 08:20:03 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: akpm@linux-foundation.org, John Stultz <johnstul@us.ibm.com>,
        maglyx@gmail.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] hpet: factor timer allocate from open
References: <201007202223.o6KMNDZl021345@imap1.linux-foundation.org> <alpine.LFD.2.00.1007231500180.2616@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1007231500180.2616@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 20 Jul 2010, akpm@linux-foundation.org wrote:
> > From: Magnus Lynch <maglyx@gmail.com>
> > 
> > The current implementation of the /dev/hpet driver couples opening the
> > device with allocating one of the (scarce) timers (aka comparators).  This
> > is a limitation in that the main counter may be valuable to applications
> > seeking a high-resolution timer who have no use for the interrupt
> > generating functionality of the comparators.
> 
> And how exactly does this patch provide such functionality ? There is
> no interface which allows you to access the counter itself.

Through mmap(); this is the only interface of /dev/hpet that is actually
used in practice.

> Cc: Clemens Ladisch <clemens@ladisch.de>

Acked-by: Clemens Ladisch <clemens@ladisch.de>


Regards,
Clemens
