Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab2LJSvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:51:10 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:4930 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249Ab2LJSvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:51:08 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VPS-12(zz98dI1432Ia65Rzz1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0METWD2-01-0OB-02
X-M-MSG: 
Date: Mon, 10 Dec 2012 12:51:00 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <rric@kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 0/6] perf, amd: Enable AMD family 15h northbridge
 counters
Message-ID: <20121210185100.GA31713@jshin-Toonie>
References: <1354748658-30567-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1354748658-30567-1-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 05:04:12PM -0600, Jacob Shin wrote:
> The following patchset enables 4 additional performance counters in
> AMD family 15h processors that count northbridge events -- such as
> number of DRAM accesses.
> 
> This patchset is based on previous work done by Robert Richter
> <rric@kernel.org> :
> 
> https://lkml.org/lkml/2012/6/19/324
> 
> The main differences are:
> 
> * The northbridge counters are indexed contiguously right above the
>   core performance counters.
> 
> * MSR address offset calculations are moved to architecture specific
>   files.
> 
> * Interrups are set up to be delivered only to a single core.
> 
> V4:
> * Moved interrupt core select set up back to event constraints
>   function, sicne during ->hw_config time we do not yet know on which
>   CPU the the event will run on.
> * Tested on and made minor revisions to make sure that the patchset is
>   compatible with upcoming AMD Family 16h processors, and will support
>   core and NB counters without any further patches.
> 
> V3:
> Addressed the following feedback/comments from Robert's review
> * https://lkml.org/lkml/2012/11/16/484
> * https://lkml.org/lkml/2012/11/26/162
> 
> V2:
> Separate out Robert's patches, and add properly ordered certificate of
> origins.
> 
> Jacob Shin (4):
>   perf, amd: Use proper naming scheme for AMD bit field definitions
>   perf, x86: Move MSR address offset calculation to architecture
>     specific files
>   perf, x86: Allow for architecture specific RDPMC indexes
>   perf, amd: Enable northbridge performance counters on AMD family 15h
> 
> Robert Richter (2):
>   perf, amd: Rework northbridge event constraints handler
>   perf, amd: Generalize northbridge constraints code for family 15h
> 
>  arch/x86/include/asm/cpufeature.h    |    2 +
>  arch/x86/include/asm/msr-index.h     |    2 +
>  arch/x86/include/asm/perf_event.h    |   13 +-
>  arch/x86/kernel/cpu/perf_event.c     |    2 +-
>  arch/x86/kernel/cpu/perf_event.h     |   25 ++-
>  arch/x86/kernel/cpu/perf_event_amd.c |  318 ++++++++++++++++++++++++++--------
>  6 files changed, 268 insertions(+), 94 deletions(-)
> 
> -- 

Ping .. ? any comments/feedback ? If things look okay, could you
please commit to tip perf/core ?

Thank you,

-Jacob

