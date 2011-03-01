Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab1CAVUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:20:32 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34902 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab1CAVUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:20:31 -0500
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 2 Mar 2011 02:49:54 +0530
Subject: RE: [PATCH v6 1/1] PRUSS UIO driver support
Thread-Topic: [PATCH v6 1/1] PRUSS UIO driver support
Thread-Index: AcvYP1sAbJEEIH3SQQiXHTz09c/qKQAFmwcg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BF36683@dbde02.ent.ti.com>
References: <1298926895-5294-1-git-send-email-pratheesh@ti.com>
 <1298926895-5294-2-git-send-email-pratheesh@ti.com>
 <20110228212638.GB16806@local>
 <B85A65D85D7EB246BE421B3FB0FBB593024BF3601C@dbde02.ent.ti.com>
 <20110301183334.GC20497@local>
In-Reply-To: <20110301183334.GC20497@local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> -----Original Message-----
> From: Hans J. Koch [mailto:hjk@hansjkoch.de]
> Sent: Wednesday, March 02, 2011 12:04 AM
> To: TK, Pratheesh Gangadhar
> Cc: Hans J. Koch; linux-kernel@vger.kernel.org; gregkh@suse.de;
> tglx@linutronix.de; sshtylyov@mvista.com; arnd@arndb.de; Chatterjee, Amit;
> davinci-linux-open-source@linux.davincidsp.com; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH v6 1/1] PRUSS UIO driver support
> 
> On Tue, Mar 01, 2011 at 10:15:27AM +0530, TK, Pratheesh Gangadhar wrote:
> > Hi,
> >
> > > -----Original Message-----
> > > From: Hans J. Koch [mailto:hjk@hansjkoch.de]
> > > Sent: Tuesday, March 01, 2011 2:57 AM
> > > To: TK, Pratheesh Gangadhar
> > > Cc: linux-kernel@vger.kernel.org; hjk@hansjkoch.de; gregkh@suse.de;
> > > tglx@linutronix.de; sshtylyov@mvista.com; arnd@arndb.de; Chatterjee,
> Amit;
> > > davinci-linux-open-source@linux.davincidsp.com; linux-arm-
> > > kernel@lists.infradead.org
> > > Subject: Re: [PATCH v6 1/1] PRUSS UIO driver support
> > >
> > > On Tue, Mar 01, 2011 at 02:31:35AM +0530, Pratheesh Gangadhar wrote:
> > > > +
> > > > +		/* Register PRUSS IRQ lines */
> > > > +		p->irq = IRQ_DA8XX_EVTOUT0 + cnt;
> > > > +		p->handler = pruss_handler;
> > > > +
> > > > +		ret = uio_register_device(&dev->dev, p);
> > > > +
> > > > +		if (ret < 0)
> > > > +			goto out_free;
> > > > +	}
> > > > +
> > > > +	spin_lock_init(&lock);
> > >
> > > That's too late. uio_register_device() enables the irq, and your
> spin_lock
> > > is not ready at that time.
> >
> > This is ok in this context as "modprobe uio_pruss" is pre-requisite for
> > running PRUSS firmware and without firmware running PRUSS won't
> > generate interrupts. Actually PRUSS INTC is not setup till we start
> > user application.
> 
> What if the user application is stopped, UIO driver module unloaded
> and loaded again?
> 
This is a possible scenario - may be a buggy application. Normally when
application is stopped, PRUs are stopped by exit handler.

> Anyway, please don't use that kind of argumentation. The next newbie
> developer might copy your work as a basis for his new driver, and there
> it probably won't work.
> 
> Simply put the spin_lock_init before the loop.
> 
Agree, will fix this in next version.

Thanks,
Pratheesh
