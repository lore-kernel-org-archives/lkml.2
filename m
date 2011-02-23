Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab1BWROE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:14:04 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7509 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab1BWROC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:14:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 23 Feb 2011 09:14:00 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Colin Cross <ccross@android.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russell King - ARM Linux (linux@arm.linux.org.uk)" 
	<linux@arm.linux.org.uk>,
        "konkers@android.com" <konkers@android.com>,
        "Olof Johansson (olof@lixom.net)" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Feb 2011 09:13:59 -0800
Subject: RE: Problem with "ARM: tegra: Move tegra_common_init to
 tegra_init_early"
Thread-Topic: Problem with "ARM: tegra: Move tegra_common_init to
 tegra_init_early"
Thread-Index: AcvTLVXK0eV5q9p4Sg2jqEq6e9e+iAAT2TIg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF03112A5CD6@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF03112A5C22@HQMAIL01.nvidia.com>
 <AANLkTimgw6kruGMp=wJUVka+Gj2cn9X=qRucbnuq-b9V@mail.gmail.com>
In-Reply-To: <AANLkTimgw6kruGMp=wJUVka+Gj2cn9X=qRucbnuq-b9V@mail.gmail.com>
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

Colin Cross wrote at Wednesday, February 23, 2011 12:43 AM:
> 
> On Tue, Feb 22, 2011 at 7:12 PM, Stephen Warren wrote:
> > The following commit makes the Tegra APB DMA engine fail to initialize
> > correctly:
> >
> > ARM: tegra: Move tegra_common_init to tegra_init_early
> > ...
> > I tried moving the call to tegra_dma_init back to each of the very end
> > of tegra_init_irq and the very beginning of tegra_harmony_init. Both
> > of these resulted in a kernel that wouldn't boot.
>
> I don't know why it still fails if you put it back at the beginning of
> the machine init, and it boots without errors on my board if I move
> tegra_dma_init to a postcore_initcall, but I don't have any drivers on
> my board that use DMA.

It looks like the fail-to-boot symptom was an operator error or
incremental build problem. I retested everything with a from-scratch
build and moving tegra_dma_int to be a postcore_initcall solves the issue
for me; I've posted a patch to do that.

-- 
nvpublic

