Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab2LNPuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:50:04 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:6651
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756267Ab2LNPuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:50:02 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VPS-12(zz98dI1432Ia65Rzz1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0MF12MY-02-NEK-02
X-M-MSG: 
Date: Fri, 14 Dec 2012 09:49:45 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] perf: Add support for hardware breakpoint address
 masks
Message-ID: <20121214154945.GA26672@jshin-Toonie>
References: <1355329843-25842-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1355329843-25842-1-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 10:30:38AM -0600, Jacob Shin wrote:
> The following patchset adds address masks to existing perf hardware
> breakpoint mechanism to allow trapping on an address range (currently
> only single address) on supported architectures.
> 
> perf uapi is updated, x86 AMD implementation (for AMD Family 16h and
> beyond) is provided, and perf tool has been extended to do:
> 
>   $ perf stat -e mem:0x1000:w:0xf a.out
>                               ^^^
>                               "don't care" bit mask
> 
>   which will count writes to [0x1000 ~ 0x1010)
> 
> Jacob Shin (2):
>   perf: Add hardware breakpoint address mask
>   perf, x86: AMD implementation for hardware breakpoint address mask
> 
> Suravee Suthikulpanit (3):
>   perf tools: Add breakpoint address mask to the mem event parser
>   perf tools: Add breakpoint address mask syntax to perf list and
>     documentation
>   perf tools: Add breakpoint address mask test case to
>     tests/parse-events
> 
>  arch/Kconfig                             |    4 ++++
>  arch/x86/Kconfig                         |    1 +
>  arch/x86/include/asm/cpufeature.h        |    2 ++
>  arch/x86/include/asm/hw_breakpoint.h     |    6 ++++++
>  arch/x86/include/asm/msr-index.h         |    6 ++++++
>  arch/x86/include/asm/processor.h         |    7 ++++++
>  arch/x86/kernel/cpu/amd.c                |   21 ++++++++++++++++++
>  arch/x86/kernel/hw_breakpoint.c          |    5 +++++
>  include/linux/hw_breakpoint.h            |    6 ++++++
>  include/uapi/linux/perf_event.h          |    5 ++++-
>  kernel/events/hw_breakpoint.c            |    3 +++
>  tools/perf/Documentation/perf-record.txt |   14 ++++++++----
>  tools/perf/tests/parse-events.c          |   34 ++++++++++++++++++++++++++++++
>  tools/perf/util/parse-events.c           |    5 +++--
>  tools/perf/util/parse-events.h           |    2 +-
>  tools/perf/util/parse-events.y           |   14 ++++++++++--
>  16 files changed, 125 insertions(+), 10 deletions(-)
> 
> -- 

Ping .. any comments / feedback ? If not, could you commit it into tip ?

Thank you,

-Jacob

