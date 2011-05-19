Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238Ab1ESSP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:15:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51499 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934060Ab1ESSPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:15:51 -0400
Date: Thu, 19 May 2011 20:15:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland Dreier <roland@kernel.org>, Milton Miller <miltonm@bga.com>,
        Hitoshi Mitake <h.mitake@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Desai, Kashyap" <Kashyap.Desai@lsi.com>,
        "Prakash, Sathya" <Sathya.Prakash@lsi.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Matthew Wilcox <matthew@wil.cx>,
        linux scsi dev <linux-scsi@vger.kernel.org>,
        "paulus@samba.org" <paulus@samba.org>,
        linux powerpc dev <linuxppc-dev@lists.ozlabs.org>,
        linux pci <linux-pci@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq is
 not atomic
Message-ID: <20110519181500.GF6139@elte.hu>
References: <1305616571.6008.23.camel@mulgrave.site>
 <B2FD678A64EAAD45B089B123FDFC3ED70157F7BCE5@inbmail01.lsi.com>
 <20110518041551.GL15227@parisc-linux.org>
 <1305692584.2580.3.camel@mulgrave.site>
 <1305702010.2781.33.camel@pasglop>
 <mpt2sas-writeq-powerpc64@mdm.bga.com>
 <4565AEA676113A449269C2F3A549520F80B66280@cosmail03.lsi.com>
 <x86-32-writeq-is-broken@mdm.bga.com>
 <BANLkTimDktq8SxOU3HZkPpj=J9pdkzVX-w@mail.gmail.com>
 <1305783242.7481.42.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305783242.7481.42.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2011-05-18 at 21:16 -0700, Roland Dreier wrote:
> > On Wed, May 18, 2011 at 11:31 AM, Milton Miller <miltonm@bga.com> wrote:
> > > So the real question should be why is x86-32 supplying a broken writeq
> > > instead of letting drivers work out what to do it when needed?
> > 
> > Sounds a lot like what I was asking a couple of years ago :)
> > http://lkml.org/lkml/2009/4/19/164
> > 
> > But Ingo insisted that non-atomic writeq would be fine:
> > http://lkml.org/lkml/2009/4/19/167
> 
> Yuck... Ingo, I think that was very wrong.
> 
> Those are for MMIO, which must almost ALWAYS know precisely what the
> resulting access size is going to be. It's not even about atomicity
> between multiple CPUs. I have seen plenty of HW for which a 64-bit
> access to a register is -not- equivalent to two 32-bit ones. In fact, in
> some case, you can get the side effects twice ... or none at all.
> 
> The only case where you can be lax is when you explicitely know that
> there is no side effects -and- the HW cope with different access sizes.
> This is not the general case and drivers need at the very least a way to
> know what the behaviour will be.

Ok, that's pretty convincing.

Unless hpa or tglx disagrees with reverting this, could any of you send a patch 
with a proper changelog etc. that applies cleanly to v2.6.39?

Thanks,

	Ingo
