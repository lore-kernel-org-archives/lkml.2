Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab1DWBil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 21:38:41 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48647 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab1DWBik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 21:38:40 -0400
Subject: Re: x86: tsc: v2 make TSC calibration more immune to interrupts
From: john stultz <johnstul@us.ibm.com>
To: Kasper Pedersen <kernel@kasperkp.dk>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <4DB08987.20403@kasperkp.dk>
References: <4DAF2B57.6010100@kasperkp.dk>
	 <1303326959.2796.136.camel@work-vm> <4DAF37B4.3040408@kasperkp.dk>
	 <1303331280.2796.154.camel@work-vm> <4DAF4E8B.6030506@kasperkp.dk>
	 <20110420223929.GB5563@feather>  <4DB08987.20403@kasperkp.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 18:38:30 -0700
Message-ID: <1303522710.2796.221.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 21:46 +0200, Kasper Pedersen wrote:
> On 04/21/2011 12:39 AM, Josh Triplett wrote:
> > 
> > Have you considered disabling interrupts while calibrating?  That would
> > ensure that you only have to care about SMIs, not arbitrary interrupts.
> >
> > Also, on more recent x86 systems you could look at MSR_SMI_COUNT (MSR
> > 0x34) to detect if any SMIs have occurred during the sample period.
> > rdmsr, start sample period, stop sample period, rdmsr, if delta of 0
> > then no SMIs occurred.  Exists on Nehalem and newer, at least.
> 
> 
> I have now tested this, and it is worth doing.

Cool! When you have the chance, send out your latest patch and I'll
review/ack and hopefully queue it for tglx.

thanks
-john


