Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1LFTjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:39:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab1LFTjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:39:11 -0500
Message-ID: <1323200328.11696.32.camel@constitution.bos.jonmasters.org>
Subject: Re: [PATCH] ARM: futex: fix clobbering oldval
From: Jon Masters <jcm@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: mhban <mhban@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DavidHowells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 06 Dec 2011 14:38:48 -0500
In-Reply-To: <20111206191109.GB5385@mudshark.cambridge.arm.com>
References: <1316660015.6872.1.camel@puffmine-laptop>
	 <20110922172653.GH13572@e102144-lin.cambridge.arm.com>
	 <1323197914.11696.30.camel@constitution.bos.jonmasters.org>
	 <20111206191109.GB5385@mudshark.cambridge.arm.com>
Organization: Red Hat, Inc.
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 19:11 +0000, Will Deacon wrote:
> Hi Jon,
> 
> On Tue, Dec 06, 2011 at 06:58:34PM +0000, Jon Masters wrote:
> > On Thu, 2011-09-22 at 18:26 +0100, Will Deacon wrote:
> > > Hi,
> > > 
> > > On Thu, Sep 22, 2011 at 03:53:35AM +0100, mhban wrote:
> > > > This patch fixes clobbering oldval bug. oldval should be preserved for next
> > > > compare operation.
> > > > 
> > > > Change-Id: I2a63bc1bdb8de330eb9e1ac02d7da1f77e6e8c3c
> > > > Signed-off-by: Minho Ban <mhban@samsung.com>
> > > 
> > > It would have been nice to have been CC'd on this...
> > > 
> > > I ran LTP tests on this, so I'm surprised that this was broken (the tests
> > > passed). Well spotted anyway!
> > 
> > This appears to be the cause of our "stuck builder" problem in Fedora
> > building certain large packages, such as OpenJDK. Some of our guys are
> > still monitoring the situation in case there's a secondary issue.
> > 
> > Was there ever any additional followup on this topic?
> 
> Yup, check commit df77abca ("ARM: 7099/1: futex: preserve oldval in SMP
> __futex_atomic_op"). It should be in stable for all affected kernels too.

Yea, Mark flagged that patch and it was included into the kernels on our
boards here. So far, it seems to be making some improvement, though we
still have stuck boards and weird signal issues sometimes. We are trying
to collect more data when this occurs (I gave the engineer concerned
some instructions around collecting data that will be of use). So I just
wondered if you saw any more futex issues, or if this is believe fixed.

Jon.


