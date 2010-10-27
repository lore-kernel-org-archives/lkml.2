Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab0J0UG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:06:59 -0400
Received: from nm10-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.194]:31939 "HELO
	nm10-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751889Ab0J0UG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:06:56 -0400
X-Yahoo-Newman-Id: 127165.22043.bm@omp1034.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: Dr6JiVoVM1nTzHglNwwds7doU5auDLThwGIRb5rIT7KeqOf
 vhhUTqkIcHyj9N3GIwEbiu0F4vMC8NkP8woySt5LS38UE56y9MrhHWJQTJZJ
 EovGslZDm.ac70tl9mg2DUWkL5GREvdxQxv4Kx_zqnnsx5WnrScnUe6epSIh
 .Rmn8jPwhQorJiVOb8dHR5a5iiYmJyLArJeFdgwagSfP4I9ZlTM8qOAvC9z8
 gAd99cTgh8N1AV0mP7wNwIZ7Zup3SnjHDaoMxSAfcr2qu66Ev.IBzkbU5kD_
 jKCD1pMQ71USv6cQfAU_5_uupOtLJxApJHPZ9QZq_AgWNwyPrgjT5vhjOPWm
 8u5AABX72U3lR63AkdSvxNnnQm042D8qe5GkDaqtaAqMkZ2Eimsuf_uVjJ0C
 WQ1NXJI27Y_o2NpGQLQMcL7C3oPeD7BProuYYnTs11uf8apI5pna6I2rjjc0
 sp_q1Jzl5FzIsb_O54YwcRx_klg--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>,
        Brian King <brking@linux.vnet.ibm.com>,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20101027192025.GA1349@linux.vnet.ibm.com>
References: <1288130914.5169.97.camel@haakon2.linux-iscsi.org>
	 <1288132071.8283.689.camel@mulgrave.site>
	 <1288132464.5169.112.camel@haakon2.linux-iscsi.org>
	 <1288133450.8283.723.camel@mulgrave.site>
	 <1288134048.5169.132.camel@haakon2.linux-iscsi.org>
	 <1288134713.19649.11.camel@mulgrave.site>
	 <1288135918.5169.149.camel@haakon2.linux-iscsi.org>
	 <20101027075349.GA32585@gargoyle.fritz.box>
	 <1288189658.4692.13.camel@mulgrave.site>
	 <1288202802.5169.202.camel@haakon2.linux-iscsi.org>
	 <20101027192025.GA1349@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 27 Oct 2010 12:55:18 -0700
Message-Id: <1288209318.5169.213.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 12:20 -0700, Mike Anderson wrote:
> Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > On Wed, 2010-10-27 at 09:27 -0500, James Bottomley wrote:
> > > On Wed, 2010-10-27 at 09:53 +0200, Andi Kleen wrote:
> > > > > This sounds like a pretty reasonable compromise that I think is slightly
> > > > > less risky for the LLDs with the ghosts and cob-webs hanging off of
> > > > > them.
> > > > 
> > > > They won't get tested either next release cycle. Essentially
> > > > near nobody uses them.
> > > > 
> > > > > 
> > > > > What do you think..?
> > > > 
> > > > Standard linux practice is to simply push the locks down. That's a pretty
> > > > mechanical operation and shouldn't be too risky
> > > > 
> > > > With some luck you could even do it with coccinelle.
> > > 
> > > Precisely ... if we can do the push down now as a mechanical
> > > transformation we can put it in the current merge window as a low risk
> > > API change.
> > 
> > I disagree that touching every single legacy LLD's SHT->queuecommand()
> > and failure paths in that code is a low rist change.
> > 
> > >   This gives us optimal exposure to the rc sequence to sort
> > > out any problems that arise (or drivers that got missed) with the lowest
> > > risk of such problems actually arising.
> > 
> > Yes, 
> > 
> > > Given the corner cases and the
> > > late arrival of fixes, the serial number changes are just too risky for
> > > the current merge window.
> > 
> > I think with andmike's testing and ACKs for the necessary scsi_error.c
> > changes this would be an acceptable risk.
> > 
> 
> Adding SCSI_EH_SOFTIRQ_DONE in scsi_softirq_done is not going to provide
> value in scsi_try_to_abort_cmd. scsi_softirq_done calls scsi_eh_scmd_add
> without the SCSI_EH_CANCEL_CMD flag set which will stop
> scsi_try_to_abort_cmd from being called.
> 
> Removing the serial_number check in scsi_try_to_abort_cmd and not
> replacing it may be the correct action as we should be relying on the
> block complete checking. That said what James has indicated about
> splitting the serial number change out seems like the lower risk approach
> at this time.
> 

Hmm, that is unfortuate..

So in this case it would make sense to drop the explict LLD usage of
scsi_cmd_get_serial(), and re-include this into scsi_dispatch_cmd() for
all LLDs and have to deal with a per scsi_host atomic_t serial_number
counter.  Anyways, I will go ahead an respin another series to follow
this logic shortly.

The other question that was mentioned in my email yesterday would be if
the clearing of a non atomic_t cmd->serial_number from
scsi_softirq_done() -> scsi_try_to_abort_cmd() is safe to begin with..?
Does this need to be converted to an atomic_t as well to present a
subtle race outside of any of the host_lock-less series of patches..?

--nab



