Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2GXQP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:15:29 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:49354
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753267Ab2GXQP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:15:28 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M7OAHE-02-0LJ-02
X-M-MSG: 
Date: Tue, 24 Jul 2012 18:15:07 +0200
From: Robert Richter <robert.richter@amd.com>
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
Message-ID: <20120724161507.GG3732@erda.amd.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
 <20120723181358.GC6717@infradead.org>
 <500EAF23.8060909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <500EAF23.8060909@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On 24.07.12 08:20:19, David Ahern wrote:
> On 7/23/12 12:13 PM, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Jul 20, 2012 at 05:25:53PM -0600, David Ahern escreveu:
> >> PEBS cannot be used with guest mode. If user adds :p modifier set
> >> exclude_guest as well.
> >
> > Is this something Intel specific? Or can someone think of an arch where
> > this limitation wouldn't exist?
> 
> Good point. So far precise_ip is used by arch/x86 only. I don't have an 
> AMD based server so I don't know if there is a conflict between 
> virtualization and IBS. Added Robert for advice.

thanks for this hint.

On AMD cpus precise_ip maps to IBS, which does not support hardware
options as perfctrs do. Thus, following attr flags are not supported:

 exclude_user, exclude_kernel, exclude_host, exclude_guest

Counting in guest mode is possible with IBS, but not the exclusion of
a certain mode. If precise_ip counting is enabled on AMD we may not
set the exclude_guest flag.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

