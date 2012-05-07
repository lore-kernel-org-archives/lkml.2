Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab2EGI4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:56:16 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:23151
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755564Ab2EGI4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:56:14 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2dI9371I1432N98dKzz1202hzz15d4Rz2dh668h839h944hd25he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3NA5M-01-5VD-02
X-M-MSG: 
Date: Mon, 7 May 2012 10:56:07 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: X86: Add mmx movq emulation
Message-ID: <20120507085607.GF4687@amd.com>
References: <1336132029-13523-1-git-send-email-joerg.roedel@amd.com>
 <4FA64D85.1000609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FA64D85.1000609@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 01:08:05PM +0300, Avi Kivity wrote:
> On 05/04/2012 02:47 PM, Joerg Roedel wrote:
> > Add support to the MMX versions of the movq instructions to
> > the instruction emulator. Also handle possible exceptions
> > they may cause.
> 
> This is already in (cbe2c9d30, e59717550e).  Are you looking at master
> instead of next?

Right, I was looking at master. Probably I should have re-read your mail
about the new git workflow.

> Since you've just thought of the issues involved, I'd appreciate a
> review of the commits above, both wrt correctness and
> maintainability.

The patches above look correct to me. In fact cbe2c9d30 is more general
than my implementation because it fetches all possible mmx operands.

My implementation on the other side should be a bit faster because it
looks for FP exceptions directly when the registers are accessed which
saves one get_fpu/put_fpu cycle (and an fwait instruction).

> In fact I already see one difference - my patches do reg &= 7, while
> your patches generate #UD for %mm8-%mm15.

Your version is correct. Documentation says that REX-prefixes are
ignored where not supported or misplaced. I also tried that directly on
hardware and it works as documented and implemented in KVM.


Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

