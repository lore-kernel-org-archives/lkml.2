Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2FEQtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:49:43 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:54593
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507Ab2FEQtm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:49:42 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -15
X-BigFish: VS-15(zzbb2dI9371I542M1432N98dKzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ahbe9i)
From: Li Yang-R58472 <r58472@freescale.com>
To: Wood Scott-B07421 <B07421@freescale.com>
CC: Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>
Subject: RE: [PATCH v5 4/5] fsl_pmc: Add API to enable device as wakeup
 event source
Thread-Topic: [PATCH v5 4/5] fsl_pmc: Add API to enable device as wakeup
 event source
Thread-Index: AQHNL2y7r6BvQOIl+0qohWyrm5d/spbmezkAgAQGN4CAAL/KgP//5sXggAE4vAD//6+5cA==
Date: Tue, 5 Jun 2012 16:49:37 +0000
Message-ID: <94F013E7935FF44C83EBE7784D62AD3F093360C1@039-SN2MPN1-022.039d.mgd.msft.net>
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com>
 <1336737235-15370-4-git-send-email-chenhui.zhao@freescale.com>
 <4FC93D74.3090200@freescale.com>
 <20120604113609.GC20676@localhost.localdomain>
 <4FCD3E8B.30805@freescale.com>
 <94F013E7935FF44C83EBE7784D62AD3F09335D27@039-SN2MPN1-022.039d.mgd.msft.net>
 <4FCE2FB8.9080307@freescale.com>
In-Reply-To: <4FCE2FB8.9080307@freescale.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [221.222.175.186]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Wednesday, June 06, 2012 12:12 AM
> To: Li Yang-R58472
> Cc: Wood Scott-B07421; Zhao Chenhui-B35336; linuxppc-dev@lists.ozlabs.org;
> linux-kernel@vger.kernel.org; galak@kernel.crashing.org
> Subject: Re: [PATCH v5 4/5] fsl_pmc: Add API to enable device as wakeup
> event source
> 
> On 06/04/2012 11:08 PM, Li Yang-R58472 wrote:
> >
> >
> >> -----Original Message-----
> >> From: Wood Scott-B07421
> >> Sent: Tuesday, June 05, 2012 7:03 AM
> >> To: Zhao Chenhui-B35336
> >> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> >> galak@kernel.crashing.org; Li Yang-R58472
> >> Subject: Re: [PATCH v5 4/5] fsl_pmc: Add API to enable device as
> >> wakeup event source
> >>
> >> On 06/04/2012 06:36 AM, Zhao Chenhui wrote:
> >>> On Fri, Jun 01, 2012 at 05:08:52PM -0500, Scott Wood wrote:
> >>>> On 05/11/2012 06:53 AM, Zhao Chenhui wrote:
> >>>>> +int mpc85xx_pmc_set_wake(struct platform_device *pdev, bool
> >>>>> +enable)
> >>>>
> >>>> Why does it have to be a platform_device?  Would a bare device_node
> >> work
> >>>> here?  If it's for stuff like device_may_wakeup() that could be in
> >>>> a platform_device wrapper function.
> >>>
> >>> It does not have to be a platform_device. I think it can be a struct
> >> device.
> >>
> >> Why does it even need that?  The low level mechanism for influencing
> >> PMCDR should only need a device node, not a Linux device struct.
> >
> > It does no harm to pass the device structure and makes more sense for
> object oriented interface design.
> 
> It does do harm if you don't have a device structure to pass, if for some
> reason you found the device by directly looking for it rather than going
> through the device model.

Whether or not a device is a wakeup source not only depends on the SoC specification but also the configuration and current state for the device.  I only expect the device driver to have this knowledge and call this function rather than some standalone platform code.  Therefore I don't think your concern matters.
 
> 
> >>>> Who is setting can_wakeup for these devices?
> >>>
> >>> The device driver is responsible to set can_wakeup.
> >>
> >> How would the device driver know how to set it?  Wouldn't this depend
> >> on the particular SoC and low power mode?
> >
> > It is based on the "fsl,magic-packet" and "fsl,wake-on-filer" device
> tree properties.
> 
> fsl,magic-packet was a mistake.  It is equivalent to checking the
> compatible for etsec.  It does not convey any information about whether

It can be described either by explicit feature property or by the compatible.  I don't think it is a problem that we choose one against another.

> the eTSEC is still active in a given low power mode.

Whether or not the eTSEC is still active in both sleep and deep sleep is only depending on if we set it to be a wakeup source.  If it behaves differently for low power modes in the future, we could address that by adding additional property.

> 
> How is fsl,wake-os-filer relevant to this decision?  When will it be set
> but not fsl,magic-packet?

I mean either fsl,magic-packet or fsl,wake-on-filer shows it can be a wakeup source.  Currently we don't have an SoC to have wake-on-filer while not wake-on-magic.  But I think it's better to consider both as they are independent features.

> 
> What about devices other than ethernet?  What about differences between
> ordinary sleep and deep sleep?

There is no difference for sleep and deep sleep for all wakeup sources currently.  We can address the problem if it is not the case in the future.

Leo

