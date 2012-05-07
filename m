Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab2EGKnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 06:43:11 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:20456 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757Ab2EGKnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 06:43:09 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2dI9371I1432N98dKzz1202hzz15d4Rz2dh668h839h944hd25he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3NF3O-02-2P4-02
X-M-MSG: 
Date: Mon, 7 May 2012 12:43:01 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: X86: Remove stale values from ctxt->memop before
 emulation
Message-ID: <20120507104300.GJ4687@amd.com>
References: <1336148056-15662-1-git-send-email-joerg.roedel@amd.com>
 <4FA634A0.8020504@redhat.com>
 <20120507101225.GH4687@amd.com>
 <4FA7A159.8050109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FA7A159.8050109@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 01:18:01PM +0300, Avi Kivity wrote:
> On 05/07/2012 01:12 PM, Joerg Roedel wrote:
> >
> > The instruction emulation for bsrw is broken in KVM because
> > the code always uses bsr with 32 or 64 bit operand size for
> > emulation. Fix that by using emulate_2op_SrcV_nobyte() macro
> > to use guest operand size for emulation.
> >
> 
> It looks fine.  Do you know what triggered this regression?  (for
> figuring out if it's 3.4 material)

Looks like it is 3.4 (and -stable) material. I tested a few older
kernels and the test passes on 3.0 but fails on 3.2 an later kernels
(I have not tested 3.1).


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

