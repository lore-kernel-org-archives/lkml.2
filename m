Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934425Ab2FHSF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 14:05:28 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:4709
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932260Ab2FHSF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 14:05:26 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(z1823lz98dIzz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5B8W7-02-0T4-02
X-M-MSG: 
Date: Fri, 8 Jun 2012 20:05:05 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        <linux-kernel@vger.kernel.org>, <andi@firstfloor.org>, <mingo@elte.hu>,
        <ming.m.lin@intel.com>, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120608180505.GA4171@aftab.osrc.amd.com>
References: <20120607071531.GA4849@quad>
 <1339064319.23343.13.camel@twins>
 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
 <1339065932.23343.18.camel@twins>
 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
 <1339067757.23343.21.camel@twins>
 <20120608093513.GA22520@gmail.com>
 <1339149613.23343.52.camel@twins>
 <1339161972.2507.13.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339161972.2507.13.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 03:26:12PM +0200, Peter Zijlstra wrote:
> The very worst is that it does per-cpu micro-code updates, not machine
> wide. This results in it being able to have different revisions on
> different cpus. This in turn makes the below O(n^2) :/

How about this: since the ucode cannot be downgraded and since higher
ucode versions are supposed to fix current and older problems (otherwise
ucoders will get an earlfull) you shouldn't be needing to verify the
ucode version on all CPUs per-CPU, i.e. the O(n^2) overhead.

Rather, simply track which CPUs _haven't_ been updated yet, and once
this is the empty set, run the verify thing to check ucode version on
all CPUs.

And this should happen only when we update ucode from version A to
version B, where B > A.

And unless I'm missing something, this should be O(n) and ucode update
should happen very seldomly anyway.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

