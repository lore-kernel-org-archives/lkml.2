Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab2BIOsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:48:09 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:49264 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753153Ab2BIOsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:48:08 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ4R2W-01-E6B-02
X-M-MSG: 
Date: Thu, 9 Feb 2012 15:32:53 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: perf: record segfaults for cycles event when collecting data on
 a VM
Message-ID: <20120209143253.GP22598@amd.com>
References: <4F32A907.6030505@gmail.com>
 <20120208174434.GI22598@amd.com>
 <4F32B680.3090502@gmail.com>
 <20120208175709.GK22598@amd.com>
 <20120209073024.GA18010@elte.hu>
 <20120209111451.GM22598@amd.com>
 <20120209133446.GD8830@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120209133446.GD8830@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 02:34:47PM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:

> > Well, there are two options:
> > 
> > 	1) Make sure machine == NULL does not happen. Changing the
> > 	   default of perf_guest back to false does exactly this for
> > 	   David's problem.
> 
> So what if it's turned on by the user? Do we still crash 
> occasionally?

It is only turned on by perf-kvm, and this path should setup a machine
object for guest samples.

> 
> > 	2) Make sure that a machine == NULL pointer is never
> > 	   dereferenced
> > 
> > I was going to fix it with option 1. Do you suggest option 2 is better?
> 
> Looks like the better fix. You said:
> 
> > Bottom line is that the perf-tool may receive samples tagged 
> > as GUEST_KERNEL even when guest-sampling is disabled (probably 
> > a race-condition). The perf-tool can not find a valid machine 
> > pointer for such a sample and passes NULL down to the other 
> > functions. And some functions don't seem to handle this.
> 
> tooling should never be surprised by getting some unexpected 
> sample via the perf.data or the ring-buffer - regardless of 
> whether that functionality is default enabled or manually 
> enabled.

Yeah, right. Guest samples may also show up intentionally when the event
modifiers are used. So crashing on machine==NULL needs to be fixed.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

