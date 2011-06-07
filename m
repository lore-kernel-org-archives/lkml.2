Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1FGPEC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:04:02 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56074 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab1FGPEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:04:00 -0400
Date: Tue, 7 Jun 2011 09:03:57 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: viresh kumar <viresh.kumar@st.com>
Cc: "jgarzik@pobox.com" <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, rsarmah@appliedmicro.com,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: drivers/ata/sata_dwc_460ex.c: Do we still need "struct
 of_device_id sata_dwc_match"
Message-ID: <20110607150357.GG13072@ponder.secretlab.ca>
References: <4DEE0313.8090002@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEE0313.8090002@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 04:23:07PM +0530, viresh kumar wrote:
> 
> Hello,
> 
> sata_dwc is also present on SPEAr SoC from ST, so i am removing dependency of this
> driver from 460ex and renaming it to sata_dwc.c.
> 
> While doing that, i saw following:
> 
> static const struct of_device_id sata_dwc_match[] = {
> 	{ .compatible = "amcc,sata-460ex", },
> 	{}
> };
> MODULE_DEVICE_TABLE(of, sata_dwc_match);
> 
> 
> I don't know if this is still useful or not with platform_device, as it was with
> of_platform_*.
> 
> Should i remove it completely? or should i just rewrite following as:
> 
> static const struct of_device_id sata_dwc_match[] = {
> 	{ .compatible = "amcc,sata_dwc", },
> 	{}
> };
> MODULE_DEVICE_TABLE(of, sata_dwc_match);

No, don't remove it and don't remove the "amcc,sata-460ex" string.
The compatible property is intended to identify the exact hardware,
and removing existing strings will break deployed boards.  However, it
is fine to add new strings to the match table.

> 
> For this i will also update: arch/powerpc/boot/dts/canyonlands.dts
> 
> 		SATA0: sata@bffd1000 {
> 			compatible = "amcc,sata-460ex";
> 			reg = <4 0xbffd1000 0x800 4 0xbffd0800 0x400>;
> 			interrupt-parent = <&UIC3>;
> 			interrupts = <0x0 0x4       /* SATA */
> 				      0x5 0x4>;     /* AHBDMA */
> 		};
> 
> Thanks for your replies.
> 
> -- 
> viresh
