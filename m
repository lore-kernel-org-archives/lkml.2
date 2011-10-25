Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab1JYKkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 06:40:08 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:12984 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1JYKkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 06:40:06 -0400
X-SpamScore: -19
X-BigFish: VS-19(zz9371K168aJ542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Gang-B34182 <B34182@freescale.com>
To: "'Bounine, Alexandre'" <Alexandre.Bounine@idt.com>,
        "'Kumar Gala'" <galak@kernel.crashing.org>,
        "'linuxppc-dev@ozlabs.org'" <linuxppc-dev@ozlabs.org>,
        Zang Roy-R61911 <r61911@freescale.com>
CC: "'Andrew Morton'" <akpm@osdl.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/5][v2] fsl-rio: Add two ports and rapidio message
 units support
Thread-Topic: [PATCH 3/5][v2] fsl-rio: Add two ports and rapidio message
 units support
Thread-Index: AQHMibHLqLGhzIQ3REujUFCG1TpMXZWEciUAgACLR1CABoY9oIABLj/g
Date: Tue, 25 Oct 2011 10:39:59 +0000
Message-ID: <9A1C2A9ACC704641BC472A1588CE164713112C@039-SN1MPN1-005.039d.mgd.msft.net>
References: <1318514922-12672-1-git-send-email-galak@kernel.crashing.org>
 <1318514922-12672-2-git-send-email-galak@kernel.crashing.org>
 <1318514922-12672-3-git-send-email-galak@kernel.crashing.org>
 <0CE8B6BE3C4AD74AB97D9D29BD24E55202367762@CORPEXCH1.na.ads.idt.com>
 <9A1C2A9ACC704641BC472A1588CE164712E48E@039-SN1MPN1-005.039d.mgd.msft.net>
 <0CE8B6BE3C4AD74AB97D9D29BD24E55202368098@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E55202368098@CORPEXCH1.na.ads.idt.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.185]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Bounine, Alexandre [mailto:Alexandre.Bounine@idt.com] 
Sent: Monday, October 24, 2011 9:51 PM
To: Liu Gang-B34182; Kumar Gala; linuxppc-dev@ozlabs.org; Zang Roy-R61911
Cc: Andrew Morton; linux-kernel@vger.kernel.org
Subject: RE: [PATCH 3/5][v2] fsl-rio: Add two ports and rapidio message units support

On Sat, Oct 22, 2011 at 1:15 AM, Liu Gang-B34182 <B34182@freescale.com>
wrote:
> 
> From: Bounine, Alexandre [mailto:Alexandre.Bounine@idt.com]
> Sent: Thursday, October 20, 2011 3:54 AM
> To: Kumar Gala; linuxppc-dev@ozlabs.org
> Cc: Andrew Morton; Liu Gang-B34182; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH 3/5][v2] fsl-rio: Add two ports and rapidio
message
> units support
> 
> On Thu, Oct 13, 2011 at 10:09 AM, Kumar Gala wrote:
> >
> > From: Liu Gang <Gang.Liu@freescale.com>
> >
> > Usually, freescale rapidio endpoint can support one 1X or two 4X LP- 
> > Serial link interfaces, and rapidio message transactions can be 
> > implemented
> by
> > two
> 
> Is the number of 1x ports described correctly?
> Can we have two 1x ports as well?
> [Liu Gang-B34182] Yes you are right. endpoint can also have two 1x 
> ports. I'll correct it.
> 
> > message units. This patch adds the support of two rapidio ports and 
> > initializes message unit 0 and message unit 1. And these ports and 
> > message
> ... skip ...
> > +
> > +  /* Probe the master port phy type */  ccsr = 
> > + in_be32(priv->regs_win + RIO_CCSR + i*0x20);  port->phy_type = 
> > + (ccsr & 1) ? RIO_PHY_SERIAL :
> > RIO_PHY_PARALLEL;
> > +  dev_info(&dev->dev, "RapidIO PHY type: %s\n",
> > +    (port->phy_type == RIO_PHY_PARALLEL) ?
> > +    "parallel" :
> > +    ((port->phy_type == RIO_PHY_SERIAL) ?
> "serial"
> > :
> > +     "unknown"));
> > +  /* Checking the port training status */  if 
> > + (in_be32((priv->regs_win + RIO_ESCSR + i*0x20)) & 1)
> {
> > +   dev_err(&dev->dev, "Port %d is not ready. "
> > +    "Try to restart connection...\n", i);
> > +   switch (port->phy_type) {
> > +   case RIO_PHY_SERIAL:
> > +    /* Disable ports */
> > +    out_be32(priv->regs_win
> > +     + RIO_CCSR + i*0x20, 0);
> > +    /* Set 1x lane */
> > +    setbits32(priv->regs_win
> > +     + RIO_CCSR + i*0x20,
> 0x02000000);
> > +    /* Enable ports */
> > +    setbits32(priv->regs_win
> > +     + RIO_CCSR + i*0x20,
> 0x00600000);
> > +    break;
> > +   case RIO_PHY_PARALLEL:
> > +    /* Disable ports */
> > +    out_be32(priv->regs_win
> > +     + RIO_CCSR + i*0x20,
> 0x22000000);
> > +    /* Enable ports */
> > +    out_be32(priv->regs_win
> > +     + RIO_CCSR + i*0x20,
> 0x44000000);
> > +    break;
> > +   }
> 
> Probably this may be a good moment to drop the support for parallel 
> link.
> Especially after you renamed controller to "srio" in the device tree.
> [Liu Gang-B34182] I'm also considering if we should drop the parallel 
> link support and doorbell outbound ATMU configuration.
> I found some older powerpc chips support parallel link, like mpc8540 
> and so on. But DTS files of these chips do not support Rapidio nodes. 
> For example we can't find rapidio node in 
> arch/powerpc/boot/dts/mpc8540ads.dts file. So can we conclude that 
> these chips with parallel rapidio link do not need the support for 
> rapidio module and the code for parallel link can be removed?

We are not aware about any use of tsi500 P-RIO switches.
[Liu Gang-B34182] Yes perhaps no one uses the P-RIO switches now. I have used the tsi578 and remembered that this switch supports only 1x and 4x srio ports.
I would consider parallel implementation as an early stage of RapidIO development which may be safely dropped.
[Liu Gang-B34182] Yeah, I agree with you.
I will keep P-RIO related definitions only because they are part of the spec. I consider removing tsi500 switch driver as well.
[Liu Gang-B34182] I'll remove the support for P-RIO in fsl-rio driver. I think it's better to keep clear code than keep a rarely used function.
Moreover, we can provide separate patches if P-RIO needed again.

> 
> > +   msleep(100);
... skip ...

> 
> >
> > @@ -340,35 +327,45 @@ fsl_rio_dbell_handler(int irq, void
> > *dev_instance)
> >     " sid %2.2x tid %2.2x info %4.4x\n",
> >     DBELL_SID(dmsg), DBELL_TID(dmsg),
> DBELL_INF(dmsg));
> >
> > -  list_for_each_entry(dbell, &port->dbells, node) {
> > -   if ((dbell->res->start <= DBELL_INF(dmsg)) &&
> > -    (dbell->res->end >= DBELL_INF(dmsg))) {
> > -    found = 1;
> > -    break;
> > +  for (i = 0; i < MAX_PORT_NUM; i++) {
> > +   if (fsl_dbell->mport[i]) {
> > +    list_for_each_entry(dbell,
> > +     &fsl_dbell->mport[i]->dbells,
> node) {
> > +     if ((dbell->res->start
> > +      <= DBELL_INF(dmsg))
> > +      && (dbell->res->end
> > +      >= DBELL_INF(dmsg))) {
> > +      found = 1;
> > +      break;
> > +     }
> > +    }
> > +    if (found && dbell->dinb) {
> > +     dbell->dinb(fsl_dbell->mport[i],
> > +      dbell->dev_id,
> DBELL_SID(dmsg),
> > +      DBELL_TID(dmsg),
> > +      DBELL_INF(dmsg));
> > +     break;
> > +    }
> >     }
> >    }
> 
> Do we need to check for matching DBELL_TID and mport destID here and 
> scan only doorbell list attached to the right port? Otherwise this may 
> call service routine associated with doorbell on a wrong port.
> [Liu Gang-B34182] Do you mean to match DBELL_TID and mport DevID?


Yes.

> Usually this is a reliable method, but for the rapidio module of 
> powerpc, will encounter some problem. We set the port's DevID by the 
> register "Base Device ID CSR" defined in Rapidio Specification.
The
> rapidio module of powerpc can support two ports but have only one the 
> Base Device ID CSR. So these two ports will have the same DevID. 
> Although there are two registers "Alternate Device ID CSR" to separate 
> deviceIDs for each port, they are specific registers of the freescale 
> rapidio and can't be accessed by getting the extended
feature
> space block offset. For this doobell issue, in order to call a right 
> service routine, perhaps we should ensure that different ports in 
> different "res->start and res->end" configurations.

This gives us an issue that has to be solved at some point.
Splitting doorbell resources may be a way in this case but should be considered in context of RIO network with different endpoints and therefore it will be some device-specific quirk.

Probably the best approach in this case is to keep doorbell handler as it is now (for purpose of this patchset) and address doorbell resource assignment during enumeration/discovery. At least this has to be well commented. 
[Liu Gang-B34182] I think this is a very complex issue, and could be very difficult to be resolved if we can't separate DevIDs for each port.
Based on the current architecture of the RIO driver, the doorbell resource will be assigned by the application. For example, RIONET will assign the doorbell resource like this:
	if ((rc = rio_request_inb_dbell(rnet->mport,
					(void *)ndev,
					RIONET_DOORBELL_JOIN,
					RIONET_DOORBELL_LEAVE,
					rionet_dbell_event)) < 0)
		goto out;
The res->start and res->end were defined by RIONET to RIONET_DOORBELL_JOIN (0x1000) and RIONET_DOORBELL_LEAVE (0x1001). And RIONET will send a doorbell
package like this:
	rio_send_doorbell(peer->rdev, RIONET_DOORBELL_JOIN); 
When the destination port of this doorbell package has been assigned the same res->start and res->end, it can work well. But when we try to address doorbell resource assignment during enumeration/discovery, and give the different doorbell resource to different port, how an endpoint to get the destination port resource it wants to send to a doorbell package?

In fact, I also encountered some other issues due to the two ports sharing one CSR. For example the "Host base device ID lock command and status register" and "Port General control command and status register", these caused some issues when enumeration/discovery, and very difficult to be resolved
based on current RIO architecture.

> 
> > -  if (found) {
> > -   dbell->dinb(port, dbell->dev_id,
> > -     DBELL_SID(dmsg),
> > -     DBELL_TID(dmsg),
> DBELL_INF(dmsg));
> > -  } else {
> > +
> > +  if (!found) {
> >     pr_debug
> >      ("RIO: spurious doorbell,"
> >      " sid %2.2x tid %2.2x info %4.4x\n",
> >      DBELL_SID(dmsg), DBELL_TID(dmsg),
> >      DBELL_INF(dmsg));
> >    }
> > -  setbits32(&rmu->msg_regs->dmr, DOORBELL_DMR_DI);
> > -  out_be32(&rmu->msg_regs->dsr, DOORBELL_DSR_DIQI);
> > +  setbits32(&fsl_dbell->dbell_regs->dmr, DOORBELL_DMR_DI);  
> > + out_be32(&fsl_dbell->dbell_regs->dsr,
> DOORBELL_DSR_DIQI);
> >   }
> >
> >  out:
> >   return IRQ_HANDLED;
> >  }
> >
... skip ...
 
Regards,

Alex.


