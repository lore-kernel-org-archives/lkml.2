Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910Ab0I0QpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:45:21 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:15435 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759900Ab0I0QpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:45:16 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2cK1432N98dN10d1Izz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9EZV1-01-RIS-02
X-M-MSG: 
Date: Mon, 27 Sep 2010 18:45:02 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 3/7] x86, NMI, Rename memory parity error to PCI
 SERR error
Message-ID: <20100927164502.GS13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-3-git-send-email-ying.huang@intel.com>
 <20100927080106.GA32222@erda.amd.com>
 <1285576760.20791.70.camel@yhuang-dev>
 <20100927090056.GJ13563@erda.amd.com>
 <20100927153315.GB26290@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100927153315.GB26290@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.09.10 11:33:15, Don Zickus wrote:
> On Mon, Sep 27, 2010 at 11:00:56AM +0200, Robert Richter wrote:
> > On 27.09.10 04:39:20, Huang Ying wrote:
> > > > I already commented on this, patch #1 and #3 are basically the same in
> > > > most parts which should be merged. What remains then in this patch is
> > > > the modified printk() and the comment. Both could be added to #1 too
> > > > which is then some sort of code cleanup patch.
> > > 
> > > Don thinks it is Ok to keep 2 patches.
> > 
> > I don't like reviewing new changes which are thrown away with the next
> > patch. I review things twice and it is much harder to see what really
> > changed then. Also we should have a clean history.
> 
> I didn't care either way.  But if it makes it easier to review, it's nice
> to keep reviewers happy too. :-)

Yes, thanks, this makes me happy. :)

> 
> Hunag, I think there is going to be a V3 of this series, could you just
> combine these patches then?
> 
> > 
> > And with git it is fairly easy to join patches.
> > 
> > > 
> > > > >  #define NMI_REASON_CLEAR_IOCHK	0x08
> > > > >  #define NMI_REASON_CLEAR_MASK	0x0f
> > > > >  
> > > > > --- a/arch/x86/kernel/traps.c
> > > > > +++ b/arch/x86/kernel/traps.c
> > > > > @@ -301,15 +301,14 @@ gp_in_kernel:
> > > > >  }
> > > > >  
> > > > >  static notrace __kprobes void
> > > > > -mem_parity_error(unsigned char reason, struct pt_regs *regs)
> > > > > +pci_serr_error(unsigned char reason, struct pt_regs *regs)
> > > > >  {
> > > > > -	printk(KERN_EMERG
> > > > > -		"Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
> > > > > -			reason, smp_processor_id());
> > > > > -
> > > > > -	printk(KERN_EMERG
> > > > > -		"You have some hardware problem, likely on the PCI bus.\n");
> > > > > +	printk(KERN_EMERG "NMI: PCI system error (SERR).\n");
> > > > 
> > > > You should keep reporting the cpu id to identify the affected node and
> > > > also the reason.
> > > 
> > > Ok. I will add CPU ID in message. Because we know the reason, I don't
> > > think we need the reason in message.
> > 
> > You only know that bit 7 is set, not the rest. As this is an error
> > message we should provide as much information as possible.
> 
> Well, what other info do we know besides that bit being set?  (I wish we
> had more, but I don't think we do)

We should keep printing the reason byte as it did before.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

