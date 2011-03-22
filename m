Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab1CVOi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:38:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57930 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab1CVOi5 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Mar 2011 10:38:57 -0400
Date: Tue, 22 Mar 2011 10:38:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: John Stultz <john.stultz@linaro.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: 2.6.39 crashes BUG: unable to handle kernel NULL pointer
 dereference at 000000000000042 .. cmos_checkintr+0x4d/0x55 under Xen as PV
 guest.
Message-ID: <20110322143841.GA26952@dumpdata.com>
References: <20110318203830.GA9262@dumpdata.com>
 <1300485566.2731.46.camel@work-vm>
 <20110319025134.GA3298@dumpdata.com>
 <1300736400.2731.66.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300736400.2731.66.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D88B474.0018,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > No. 2.6.38 vaniall works great.
> 
> Ok. Hrm. 
> 
> > > Any insight there?
> > 
> > I hoped you might have :-)
> 
> Could you help me understand where in the probe logic xen bombs out of
> the cmos code?

Sure. The issue is that rtc_update_irq calls schedule_work with rtc->irqwork
which has not been initialized. The reason for that is that rtc_device_register
has never been called.. uh wait, that does not make sense, it is called in
cmos_do_probe. Hmm, let get find out exactly on which variable queue_work_on
bombs out on.

