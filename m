Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1AFR2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:28:44 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:31872
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524Ab1AFR2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:28:43 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bh8275dhz32i637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEM37K-02-19F-02
X-M-MSG: 
Date: Thu, 6 Jan 2011 18:28:34 +0100
From: Robert Richter <robert.richter@amd.com>
To: Jan Beulich <JBeulich@novell.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: use PCI method for enabling AMD extended config
 space before MSR method
Message-ID: <20110106172834.GN4739@erda.amd.com>
References: <4D26028F020000780002AC8A@vpn.id2.novell.com>
 <20110106172004.GM4739@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110106172004.GM4739@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.01.11 18:20:04, Robert Richter wrote:
> On 06.01.11 11:57:35, Jan Beulich wrote:
> > While both methods should work equivalently well for the native case,
> > the Xen Dom0 case can't reliably work with the MSR one, since there's
> > no guarantee that the virtual CPUs it has available fully cover all
> > necessary physical ones.
> > 
> > As per the suggestion of Robert Richter the patch only adds the PCI
> > method, but leaves the MSR one as a fallback to cover new systems the
> > PCI IDs of which may not have got added to the code base yet.
> > 
> > Signed-off-by: Jan Beulich <jbeulich@novell.com>
> > Cc: Robert Richter <robert.richter@amd.com>
> > Cc: Joerg Roedel <Joerg.Roedel@amd.com>
> > Cc: Andreas Herrmann <Andreas.Herrmann3@amd.com>
> > Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> > 
> > ---
> >  arch/x86/include/asm/amd_nb.h |    7 ++++++
> >  arch/x86/kernel/amd_nb.c      |    7 ++++++
> >  arch/x86/kernel/aperture_64.c |   44 +++++++++++++++---------------------------
> >  arch/x86/pci/amd_bus.c        |   30 ++++++++++++++++++++++++++++
> >  4 files changed, 60 insertions(+), 28 deletions(-)

Btw, the patch should be relative to tip/x86/amd-nb as there would be
conflicts otherwise due to other changes.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

