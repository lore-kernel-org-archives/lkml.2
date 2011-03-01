Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab1CAJxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 04:53:34 -0500
Received: from www.tglx.de ([62.245.132.106]:44644 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093Ab1CAJxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 04:53:33 -0500
Date: Tue, 1 Mar 2011 10:53:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v6 1/1] PRUSS UIO driver support
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BF3601C@dbde02.ent.ti.com>
Message-ID: <alpine.LFD.2.00.1103011052020.2701@localhost6.localdomain6>
References: <1298926895-5294-1-git-send-email-pratheesh@ti.com> <1298926895-5294-2-git-send-email-pratheesh@ti.com> <20110228212638.GB16806@local> <B85A65D85D7EB246BE421B3FB0FBB593024BF3601C@dbde02.ent.ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, TK, Pratheesh Gangadhar wrote:
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

No, it's not. If you enable interrupts you have to be prepared for
getting one whether the device mask is enabled or not. It's that
simple.

Thanks,

	tglx
