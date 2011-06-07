Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab1FGKyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:54:39 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:50220 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398Ab1FGKyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:54:36 -0400
Message-ID: <4DEE0313.8090002@st.com>
Date: Tue, 7 Jun 2011 16:23:07 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "jgarzik@pobox.com" <jgarzik@pobox.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Grant Likely <grant.likely@secretlab.ca>, <rsarmah@appliedmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: drivers/ata/sata_dwc_460ex.c: Do we still need "struct of_device_id
 sata_dwc_match"
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

sata_dwc is also present on SPEAr SoC from ST, so i am removing dependency of this
driver from 460ex and renaming it to sata_dwc.c.

While doing that, i saw following:

static const struct of_device_id sata_dwc_match[] = {
	{ .compatible = "amcc,sata-460ex", },
	{}
};
MODULE_DEVICE_TABLE(of, sata_dwc_match);


I don't know if this is still useful or not with platform_device, as it was with
of_platform_*.

Should i remove it completely? or should i just rewrite following as:

static const struct of_device_id sata_dwc_match[] = {
	{ .compatible = "amcc,sata_dwc", },
	{}
};
MODULE_DEVICE_TABLE(of, sata_dwc_match);

For this i will also update: arch/powerpc/boot/dts/canyonlands.dts

		SATA0: sata@bffd1000 {
			compatible = "amcc,sata-460ex";
			reg = <4 0xbffd1000 0x800 4 0xbffd0800 0x400>;
			interrupt-parent = <&UIC3>;
			interrupts = <0x0 0x4       /* SATA */
				      0x5 0x4>;     /* AHBDMA */
		};

Thanks for your replies.

-- 
viresh
