Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab2BILPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 06:15:04 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:14359
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961Ab2BILPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 06:15:02 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ4HWT-02-2NJ-02
X-M-MSG: 
Date: Thu, 9 Feb 2012 12:14:51 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: perf: record segfaults for cycles event when collecting data on
 a VM
Message-ID: <20120209111451.GM22598@amd.com>
References: <4F32A907.6030505@gmail.com>
 <20120208174434.GI22598@amd.com>
 <4F32B680.3090502@gmail.com>
 <20120208175709.GK22598@amd.com>
 <20120209073024.GA18010@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120209073024.GA18010@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 08:30:24AM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > > which makes sense. It forces 
> > > perf_session__find_machine_for_cpumode() to return the host 
> > > machine always.
> > 
> > Great, thanks. I will send two patches tomorrow to fix Jason's 
> > problem and change the default for perf_guest.
> 
> Well, if the crash is fixed then the the default can stay, 
> right?

David's crash is fixed by changing the default back to its original
value :)

> Generally we should treat all input data in a perf.data or even 
> the bits we get in the ring-buffer as external data that has to 
> be checked carefully, with no assumptions made about data.

Well, there are two options:

	1) Make sure machine == NULL does not happen. Changing the
	   default of perf_guest back to false does exactly this for
	   David's problem.
	2) Make sure that a machine == NULL pointer is never
	   dereferenced

I was going to fix it with option 1. Do you suggest option 2 is better?


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

