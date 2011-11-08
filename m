Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab1KHQoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:44:01 -0500
Received: from mail-va3.bigfish.com ([216.32.180.10]:28604 "EHLO
	VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754684Ab1KHQn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:43:57 -0500
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Nov 2011 11:43:56 EST
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R8275bhz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LUCOFE-02-4OX-02
X-M-MSG: 
Date: Tue, 8 Nov 2011 17:28:26 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Subject: Re: [PATCH] pci: More PRI/PASID cleanup
Message-ID: <20111108162826.GD5182@amd.com>
References: <20111103034359.10286.19062.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111103034359.10286.19062.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 11:53:56PM -0400, Alex Williamson wrote:
> More consistency cleanups.  Drop the _OFF, separate and indent
> CTRL/CAP/STATUS bit definitions, fix that PASID_CAP doesn't
> actually report the ENABLE bit.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> Joerg, I can't test this, so you may want to make sure I'm not
> breaking your API.  The March 31, 2011 version of the PASID ECN
> shows bit 0 of the PASID capability register as reserved, not
> an indicator of support for or status of the enable bit.
> Presumably the entire capability wouldn't be included if it
> can't be enabled.  With the below, pci_enable_pasid() now checks
> the right bit, but also pci_pasid_features() no longer masks in
> bit 0, but being reserved, it should have been clear anyway.

Looks like you are only renaming stuff. I don't see the real point but I
also don't object unless this will be merged upstream soon. I plan to
push the code using these capabilities for the next merge-window and if
this one will me merged then too it will cause a lot of pain.

	
	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

