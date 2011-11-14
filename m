Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1KNQUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 11:20:43 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5738 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1KNQUm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 11:20:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 14 Nov 2011 08:20:41 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Rob Herring <robherring2@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 14 Nov 2011 08:20:38 -0800
Subject: RE: [PATCH v4 01/10] arm/tegra: initial device tree for tegra30
Thread-Topic: [PATCH v4 01/10] arm/tegra: initial device tree for tegra30
Thread-Index: Acyi52K74TeMhaH3R9mvCDDxYuem4wAAaa8Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740805A80@HQMAIL01.nvidia.com>
References: <1321010541-31337-1-git-send-email-pdeschrijver@nvidia.com>
 <1321010541-31337-2-git-send-email-pdeschrijver@nvidia.com>
 <4EBDE766.5080505@gmail.com>
 <20111114152518.GJ19069@tbergstrom-lnx.Nvidia.com>
 <4EC13699.5030205@gmail.com>
 <20111114160633.GK19069@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20111114160633.GK19069@tbergstrom-lnx.Nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter De Schrijver wrote at Monday, November 14, 2011 9:07 AM:
> On Mon, Nov 14, 2011 at 04:41:13PM +0100, Rob Herring wrote:
> > On 11/14/2011 09:25 AM, Peter De Schrijver wrote:
> > > On Sat, Nov 12, 2011 at 04:26:30AM +0100, Rob Herring wrote:
> > >> On 11/11/2011 05:22 AM, Peter De Schrijver wrote:
> > >>> This patch adds the initial device tree for tegra30
...
> > >>> +	interrupt-parent = <&intc>;
> > >>> +
> > >>> +	intc: interrupt-controller@50041000 {
> > >>> +		compatible = "nvidia,tegra30-gic", "nvidia,tegra20-gic";
> > >>> +		interrupt-controller;
> > >>> +		#interrupt-cells = <1>;
> > >>
> > >> Is the Tegra GIC really different from a standard A9 gic? You need to
> > >> update to use the gic binding. The cells should be 3 for example.
> > >
> > > It has an extra 'legacy' interrupt controller like tegra20 has. This is used
> > > when waking up the CPU from power off mode.
> >
> > Although that is probably not part of the GIC h/w (i.e. at a different
> > address) and should be described in the dts separately. That doesn't
> > change the GIC binding or the fact that you are using
> > arch/arm/common/gic.c though. Whether you have a different compatible
> > string or not is not really the issue. That can already be supported if
> > necessary. The issue is you are not using the existing GIC binding as a
> > starting point and that has implications on every node using a GIC
> > interrupt.
> >
> 
> The GIC is the same as the one used on tegra20. So I copied the binding from
> tegra20.dtsi. Is that one wrong too then?

The existing Tegra20 .dtsi file doesn't use the new GIC bindings yet
either, which as Peter points out is where he copied the GIC node from.
My suggestion is that we merge the Tegra30 .dtsi as shown above, and then
do a single pass to convert both tegra20.dtsi and tegra30.dtsi over to the
new GIC binding, to prevent blocking the merge of tegra30.dtsi on the GIC
binding rework. Does that sound fair?

-- 
nvpublic

