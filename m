Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab0EZWYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:24:30 -0400
Received: from smtp.microsoft.com ([131.107.115.212]:2480 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab0EZWY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:24:28 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization (modified)
Thread-Topic: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization (modified)
Thread-Index: AQHK/PQk4Q0BKOsjtUu1BYK6E0Db25JkpeQA//+OILCAAIHWAP//kGFA
Date: Wed, 26 May 2010 22:23:08 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7266B8C775@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7266B8C4AC@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100526205134.GC7343@suse.de>
 <1FB5E1D5CA062146B38059374562DF7266B8C72B@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100526214842.GA27908@suse.de>
In-Reply-To: <20100526214842.GA27908@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@suse.de]
> > As discussed previously, I used atomic_t to handle more general case
> > if vmbus interrupts happen on every cpu.
> 
> Ok, but then you should use a lock to protect the variable, not an
> atomic_t.
> If you care about this, because some other thread is looking at it,
> then
> you really need to protect it with a lock.  Don't rely on a mb() to get
> it all correct for you (hint, I doubt it will...)

Actually, since the interrupts only happen on cpu0, this is not a concern. How about use a simple int variable here? Also, remove the mb().

> > The ic_channel_ready variable is called by VmbusChannelProcessOffer /
> > osd_WaitEventSet(ic_channel_ready) to wake up vmbus_init(). So it's
> > not a local variable.
> 
> But again, this logic should be within the init call, as it's part of
> the proper init sequence.  So just put it in that call please.

The VmbusChannelProcessOffer() is called from interrupt context, and initialize the channels, wake up vmbus_init when all channels are ready. If using local variable only, how to pass the channel ready info to vmbus_init() which is in a different context?

Thanks,

- Haiyang

