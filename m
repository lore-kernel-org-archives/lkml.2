Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab1CASer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 13:34:47 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:49682 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162Ab1CASeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 13:34:46 -0500
Date: Tue, 1 Mar 2011 19:33:35 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 1/1] PRUSS UIO driver support
Message-ID: <20110301183334.GC20497@local>
References: <1298926895-5294-1-git-send-email-pratheesh@ti.com>
 <1298926895-5294-2-git-send-email-pratheesh@ti.com>
 <20110228212638.GB16806@local>
 <B85A65D85D7EB246BE421B3FB0FBB593024BF3601C@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BF3601C@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 10:15:27AM +0530, TK, Pratheesh Gangadhar wrote:
> Hi,
> 
> > -----Original Message-----
> > From: Hans J. Koch [mailto:hjk@hansjkoch.de]
> > Sent: Tuesday, March 01, 2011 2:57 AM
> > To: TK, Pratheesh Gangadhar
> > Cc: linux-kernel@vger.kernel.org; hjk@hansjkoch.de; gregkh@suse.de;
> > tglx@linutronix.de; sshtylyov@mvista.com; arnd@arndb.de; Chatterjee, Amit;
> > davinci-linux-open-source@linux.davincidsp.com; linux-arm-
> > kernel@lists.infradead.org
> > Subject: Re: [PATCH v6 1/1] PRUSS UIO driver support
> > 
> > On Tue, Mar 01, 2011 at 02:31:35AM +0530, Pratheesh Gangadhar wrote:
> > > +
> > > +		/* Register PRUSS IRQ lines */
> > > +		p->irq = IRQ_DA8XX_EVTOUT0 + cnt;
> > > +		p->handler = pruss_handler;
> > > +
> > > +		ret = uio_register_device(&dev->dev, p);
> > > +
> > > +		if (ret < 0)
> > > +			goto out_free;
> > > +	}
> > > +
> > > +	spin_lock_init(&lock);
> > 
> > That's too late. uio_register_device() enables the irq, and your spin_lock
> > is not ready at that time.
> 
> This is ok in this context as "modprobe uio_pruss" is pre-requisite for
> running PRUSS firmware and without firmware running PRUSS won't
> generate interrupts. Actually PRUSS INTC is not setup till we start
> user application.

What if the user application is stopped, UIO driver module unloaded
and loaded again?

Anyway, please don't use that kind of argumentation. The next newbie
developer might copy your work as a basis for his new driver, and there
it probably won't work.

Simply put the spin_lock_init before the loop.

Thanks,
Hans
