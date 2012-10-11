Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab2JKJcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 05:32:46 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:11334
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755634Ab2JKJco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 05:32:44 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIzz1202h1d1ah1d2ahzz8275ch15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
X-WSS-ID: 0MBQ2IC-02-06P-02
X-M-MSG: 
Date: Thu, 11 Oct 2012 11:32:39 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Oakley <andrew@ado.is-a-geek.net>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] IOMMU Updates for v3.7-rc1
Message-ID: <20121011093239.GA2619@amd.com>
References: <20121005152312.GA4649@8bytes.org>
 <20121009224532.1e515664@ado-amd-gentoo.moore.slainvet.net>
 <20121010073022.GB16151@8bytes.org>
 <20121010095823.140fdd98@ado-amd-gentoo.moore.slainvet.net>
 <20121010133249.GC16151@8bytes.org>
 <20121010201131.091d5a1f@ado-amd-gentoo.moore.slainvet.net>
 <20121010230231.2fb3c3b9@ado-amd-gentoo.moore.slainvet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121010230231.2fb3c3b9@ado-amd-gentoo.moore.slainvet.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 11:02:31PM +0100, Andrew Oakley wrote:
> On Wed, 10 Oct 2012 20:11:31 +0100
> Andrew Oakley <andrew@ado.is-a-geek.net> wrote:

> I'm not sure if the fix I've got is safe or if it's really a good idea
> to enable interrupt remapping with a broken BIOS.

Sadly it is not. Your patch works for your particular case but is not
generally applicable. There are indeed systems with 2 or more IOAPICs
and they all use different device-ids.

So, typically, there is one IOAPIC per SB, like in your case. But on
RD890 the chipset NB also includes an IOAPIC (which uses
device-id 00:00.1). This IOAPIC exists on your system too but is
disabled by the BIOS because the board does not use it.

So, in the end, device-id 00:00.1 might also be correct and the IVRS
entry could refer to the NB IOAPIC. We don't have any reliable
indication which IOAPIC is described in the IVRS table.

Cheer,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

