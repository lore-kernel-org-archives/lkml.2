Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab0IMPck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:32:40 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:40286 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630Ab0IMPcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:32:39 -0400
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Sep 2010 11:32:38 EDT
X-IronPort-AV: E=Sophos;i="4.56,359,1280700000"; 
   d="scan'208";a="59197388"
Date: Mon, 13 Sep 2010 17:22:49 +0200
From: Samuel Thibault <Samuel.Thibault@ens-lyon.org>
To: Valdis.Kletnieks@vt.edu
Cc: =?iso-8859-1?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andres Salomon <dilinger@queued.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
Message-ID: <20100913152249.GC5364@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <Samuel.Thibault@ens-lyon.org>,
	Valdis.Kletnieks@vt.edu,
	=?iso-8859-1?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Andres Salomon <dilinger@queued.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20100825094925.GA3632@pema> <alpine.LFD.2.00.1008261406480.2062@localhost.localdomain> <20100826210815.GA18131@pema> <4C76D9A0.2010907@zytor.com> <20100829205929.GA3309@pema> <20100913100719.GA3903@pema> <54870.1284390647@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54870.1284390647@localhost>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu, le Mon 13 Sep 2010 11:10:47 -0400, a écrit :
> On Mon, 13 Sep 2010 12:07:19 +0200, Shérab said:
> 
> > +static int iris_init(void)
> > +{
> > +	unsigned char status = inb(IRIS_GIO_INPUT);
> > +	if (status == IRIS_GIO_NODEV) {
> > +		printk(KERN_ERR "This machine does not seem to be an Iris. Power_off handler not installed.\n");
> > +		return -ENODEV;
> > +	}
> 
> Is it actually safe to assume that this will do the right thing on a machine that
> is a non-Iris that has something *else* at that I/O  address?

No.

> Any further sanity checking we can do?

No. The format of the value there is quite unknown, it's just quite sure
it won't be 0xff on the Iris.

Again, I'm not sure we really should try hard to make it automatically
detected (and thus always enabled).  Having to pass a kernel parameter
to enable the functionality is completely fine, since installing Linux
on this device requires quite some tinkering already.

Samuel
