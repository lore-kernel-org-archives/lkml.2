Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab0FFRsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 13:48:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54776 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab0FFRsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 13:48:17 -0400
Date: Sun, 6 Jun 2010 18:48:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] suspend blockers & Android integration
Message-ID: <20100606174812.GA13640@srcf.ucam.org>
References: <AANLkTilQ1k78dDCYadOa1Wiyjm2nsBcRpxwdpGvYcf8z@mail.gmail.com> <AANLkTin7oM3gVwHbIHWqYV8yeC6bbQ4q2jDDxAgz3DwQ@mail.gmail.com> <20100606133130.GA8513@srcf.ucam.org> <AANLkTimXTgZS_fZQa8hjIptJrCn756gF_xakT1IQiLWa@mail.gmail.com> <20100606152946.GA11351@srcf.ucam.org> <AANLkTilOq_5yUW1AIMH1qSE699gyRUTlzGPUVc4CrReY@mail.gmail.com> <20100606164326.GA12570@srcf.ucam.org> <AANLkTim0JD4V0RTc6CRIADypqYhQo3JYp3dJs0l7g7Ps@mail.gmail.com> <20100606173146.GA13432@srcf.ucam.org> <AANLkTimCd4AUk1wBBcnX9WKvpKA6sNfs8-4Qqb5wMaNH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimCd4AUk1wBBcnX9WKvpKA6sNfs8-4Qqb5wMaNH@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 06, 2010 at 07:37:59PM +0200, Vitaly Wool wrote:
> 2010/6/6 Matthew Garrett <mjg59@srcf.ucam.org>:
> > On Sun, Jun 06, 2010 at 07:21:49PM +0200, Vitaly Wool wrote:
> >> 2010/6/6 Matthew Garrett <mjg59@srcf.ucam.org>:
> >>
> >> > Suspend blocks prevent system suspend, not any per-device suspend.
> >>
> >> Can you suspend a device which is holding a wake lock?
> >
> > Yes. Suspend blocks are orthogonal to runtime PM.
> 
> That's nice, but that means that it can hold the wake lock
> indefinitely. Brilliant design, I'd say.

Putting a device in a low power state doesn't mean you can't run code in 
the driver. If a device generates an event and that event gets handled 
by the driver, the driver can take a suspend block and then release it 
when userspace reads the event. It's perfectly valid for the device to 
go into a low power state in the meantime. When I say that these things 
are orthogonal, I really do mean it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
