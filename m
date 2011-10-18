Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1JRGhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:37:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54547 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab1JRGhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:37:16 -0400
Date: Tue, 18 Oct 2011 08:35:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dan McGrath <troubledaemon@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Nieder <jrnieder@gmail.com>,
        Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [PATCH] x86: mpparse: fix mp_bus_not_pci handling
Message-ID: <20111018063533.GJ16304@elte.hu>
References: <20110925212900.10713.67058.stgit@bhelgaas.mtv.corp.google.com>
 <CAErSpo6UyfP4mHUK7-wpvDUQ75n4z+rtgWQj-4NSvPCBK_KKbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo6UyfP4mHUK7-wpvDUQ75n4z+rtgWQj-4NSvPCBK_KKbQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bjorn Helgaas <bhelgaas@google.com> wrote:

> On Sun, Sep 25, 2011 at 3:29 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > Dan bisected a Dell PowerEdge 4200 boot regression to commit f8924e770.
> > Prior to that commit, 32-bit kernels set mp_bus_not_pci for all buses
> > except PCI.  Afterwards, we set mp_bus_not_pci only for ISA.  But ISA is
> > not the only non-PCI bus, so it's better to always set mp_bus_not_pci
> > and clear it only for PCI.
> >
> > The workaround was to boot with "noapic".  Dan verified that with this
> > patch, his system boots without "noapic".
> >
> > Reference: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=586494
> > Reported-and-tested-by: Dan McGrath <troubledaemon@gmail.com>
> > Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
> > Cc: stable@kernel.org # 2.6.26+
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > ---
> >  arch/x86/kernel/mpparse.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
> > index 9103b89..0741b062 100644
> > --- a/arch/x86/kernel/mpparse.c
> > +++ b/arch/x86/kernel/mpparse.c
> > @@ -95,8 +95,8 @@ static void __init MP_bus_info(struct mpc_bus *m)
> >        }
> >  #endif
> >
> > +       set_bit(m->busid, mp_bus_not_pci);
> >        if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
> > -               set_bit(m->busid, mp_bus_not_pci);
> >  #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
> >                mp_bus_id_to_type[m->busid] = MP_BUS_ISA;
> >  #endif
> >
> >
> 
> Ping?  I don't see this in linux-next, so I don't know if it got
> dropped or if there's something wrong with it.

Please resend - this is one of the mails that got lost in my korg 
email disconnect.

Patch looks good at first sight.

Thanks,

	Ingo
