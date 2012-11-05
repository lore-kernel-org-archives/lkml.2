Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab2KEXMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:12:08 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:15758
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932978Ab2KEXMD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:12:03 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:error;EFVD:FOP
X-SpamScore: -3
X-BigFish: VS-3(z551bizbb2dI98dI9371I1432Izz1de0h1202h1d1ah1d2ahzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h1155h)
Date: Mon, 5 Nov 2012 17:11:15 -0600
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 4/4 v4] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
To: Timur Tabi <timur@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>, <joerg.roedel@amd.com>,
        <iommu@lists.linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
References: <1352114361-25192-1-git-send-email-Varun.Sethi@freescale.com>
	<1352114361-25192-2-git-send-email-Varun.Sethi@freescale.com>
	<1352114361-25192-3-git-send-email-Varun.Sethi@freescale.com>
	<1352114361-25192-4-git-send-email-Varun.Sethi@freescale.com>
	<509845ED.2060904@freescale.com>
In-Reply-To: <509845ED.2060904@freescale.com> (from timur@freescale.com on
	Mon Nov  5 17:04:13 2012)
X-Mailer: Balsa 2.4.11
Message-ID: <1352157075.28279.10@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 05:04:13 PM, Timur Tabi wrote:
> Varun Sethi wrote:
> > +	/* PAACE Offset 0x00 */
> > +	u32 wbah;				/* only valid for  
> Primary PAACE */
> > +	u32 addr_bitfields;		/* See P/S PAACE_AF_* */
> > +
> > +	/* PAACE Offset 0x08 */
> > +	/* Interpretation of first 32 bits dependent on DD above */
> > +	union {
> > +		struct {
> > +			/* Destination ID, see PAACE_DID_* defines */
> > +			u8 did;
> > +			/* Partition ID */
> > +			u8 pid;
> > +			/* Snoop ID */
> > +			u8 snpid;
> > +			/* coherency_required : 1 reserved : 7 */
> 
> Please use this format, which is easier to read:
> 
> 			/* 1 == coherency required, 7 == reserved */
> 
> Every time I look at this comment, I think you are using bitfields.

It is meant as a pseudo-bitfield.  "7 == reserved" doesn't make much  
sense -- that would leave a lot of other values neither defined nor  
explicitly reserved.

That said, the "See PAACE_DA_*" comment should be sufficient and avoids  
making people have to care about what bitfield ordering the comment  
writer was assuming.

-Scott
