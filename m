Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab2EVJ2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:28:11 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:16645
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572Ab2EVJ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:28:08 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M4F3MN-02-A0H-02
X-M-MSG: 
Date: Tue, 22 May 2012 11:28:32 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Borislav Petkov <borislav.petkov@amd.com>,
        "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v24b] RAS: Add a tracepoint for reporting memory
 controller events
Message-ID: <20120522092832.GC18578@aftab.osrc.amd.com>
References: <4FB6866E.7090503@redhat.com>
 <20120518185258.GE20215@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F1A33@ORSMSX104.amr.corp.intel.com>
 <20120518211211.GA26464@aftab.osrc.amd.com>
 <20120519092618.GC29991@aftab.osrc.amd.com>
 <4FBA5F59.5000604@redhat.com>
 <20120521160041.GJ3334@aftab.osrc.amd.com>
 <4FBA6FE8.50707@redhat.com>
 <20120521204042.GA14255@aftab.osrc.amd.com>
 <4FBB0250.20100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FBB0250.20100@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 12:04:48AM -0300, Mauro Carvalho Chehab wrote:
> +TRACE_EVENT(mc_event,
> +
> +	TP_PROTO(const unsigned int err_type,
> +		 const unsigned int mc_index,
> +		 const char *error_msg,
> +		 const char *label,
> +		 int layer0,
> +		 int layer1,
> +		 int layer2,

Those are EDAC-internal layer representation, why are they exported to
userspace? Userspace needs only the location and label AFAICT.

If you export them to userspace, they need much more meaningful names -
layer{0,1,2} mean nothing outside of the kernel.

> +		 unsigned long pfn,
> +		 unsigned long offset,
> +		 unsigned long grain,

Why aren't those a single 'unsigned long address' since they all are
computed from it?

> +		 unsigned long syndrome,
> +		 const char *driver_detail),
> +
> +	TP_ARGS(err_type, mc_index, error_msg, label, layer0, layer1, layer2,
> +		pfn, offset, grain, syndrome, driver_detail),
> 
> The address is there using the edac way to represent it (page, offset, grain).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

