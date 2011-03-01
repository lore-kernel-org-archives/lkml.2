Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1CAEqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 23:46:01 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:55278 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab1CAEqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 23:46:00 -0500
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
Date: Tue, 1 Mar 2011 10:15:27 +0530
Subject: RE: [PATCH v6 1/1] PRUSS UIO driver support
Thread-Topic: [PATCH v6 1/1] PRUSS UIO driver support
Thread-Index: AcvXjlUD82p26xnYSRyGgeDQRmX72gAPG1oQ
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BF3601C@dbde02.ent.ti.com>
References: <1298926895-5294-1-git-send-email-pratheesh@ti.com>
 <1298926895-5294-2-git-send-email-pratheesh@ti.com>
 <20110228212638.GB16806@local>
In-Reply-To: <20110228212638.GB16806@local>
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
> Sent: Tuesday, March 01, 2011 2:57 AM
> To: TK, Pratheesh Gangadhar
> Cc: linux-kernel@vger.kernel.org; hjk@hansjkoch.de; gregkh@suse.de;
> tglx@linutronix.de; sshtylyov@mvista.com; arnd@arndb.de; Chatterjee, Amit;
> davinci-linux-open-source@linux.davincidsp.com; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH v6 1/1] PRUSS UIO driver support
> 
> On Tue, Mar 01, 2011 at 02:31:35AM +0530, Pratheesh Gangadhar wrote:
> > +
> > +		/* Register PRUSS IRQ lines */
> > +		p->irq = IRQ_DA8XX_EVTOUT0 + cnt;
> > +		p->handler = pruss_handler;
> > +
> > +		ret = uio_register_device(&dev->dev, p);
> > +
> > +		if (ret < 0)
> > +			goto out_free;
> > +	}
> > +
> > +	spin_lock_init(&lock);
> 
> That's too late. uio_register_device() enables the irq, and your spin_lock
> is not ready at that time.

This is ok in this context as "modprobe uio_pruss" is pre-requisite for
running PRUSS firmware and without firmware running PRUSS won't
generate interrupts. Actually PRUSS INTC is not setup till we start
user application.

Thanks,
Pratheesh

