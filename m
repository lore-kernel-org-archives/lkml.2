Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab2DLRKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:10:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:37746 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab2DLRKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:10:01 -0400
Date: Thu, 12 Apr 2012 19:09:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: =?ISO-8859-15?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: [v3.4-rc1] ACPI regression bisected
In-Reply-To: <alpine.LFD.2.02.1204121903250.2542@ionos>
Message-ID: <alpine.LFD.2.02.1204121907330.2542@ionos>
References: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com> <20120402235412.GD16303@tassilo.jf.intel.com> <alpine.LFD.2.02.1204031001510.2542@ionos> <CADDKRnAOqfxTjrCp4E5eKFJvVTu6s0xF3Ca3jRJavFkyGpYLmQ@mail.gmail.com>
 <alpine.LFD.2.02.1204121055200.2542@ionos> <20120412142904.GA4130@srcf.ucam.org> <alpine.LFD.2.02.1204121903250.2542@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012, Thomas Gleixner wrote:

> On Thu, 12 Apr 2012, Matthew Garrett wrote:
> 
> > On Thu, Apr 12, 2012 at 10:57:45AM +0200, Thomas Gleixner wrote:
> > 
> > > OK, so now the question is whether the ACPI interrupt can end up being
> > > shared or not.
> > 
> > Per spec:
> > 
> > "OSPM is required to treat the ACPI SCI interrupt as a sharable, level, 
> > active low interrupt."
> 
> I feared that. So now is the question whether there is a way to mask
> the interrupt at the "device" level.

If not, I could be persuaded to provide a mechanism to force thread
all interrupts which are on that line, if there's a good argument to
do so.

All machines in my farm do not share the line, so I guess it's only
relevant when you boot with apic disabled or such.

Thanks,

	tglx
