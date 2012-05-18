Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968010Ab2ERN1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:27:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42396 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761163Ab2ERN13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:27:29 -0400
MIME-Version: 1.0
In-Reply-To: <1337263737-3541-1-git-send-email-andi@firstfloor.org>
References: <1337263737-3541-1-git-send-email-andi@firstfloor.org>
Date: Fri, 18 May 2012 21:27:29 +0800
Message-ID: <CAJd=RBCwLOxQwfmppxxJjfJzEJ+RSoL4MaE9wKtSrotKe2J56w@mail.gmail.com>
Subject: Re: [PATCH] Add ACPI and power trace points for laptop overheating
From: Hillf Danton <dhillf@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi

On Thu, May 17, 2012 at 10:08 PM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Add trace points for ACPI power events which are important for a laptop's
> thermal: acpi throttling/pstate, ec communication, GPU overheating. Useful
> for understanding the thermal behaviour of laptops on the thermal edge.
>
> The generic power events have gpu_limit, overtemp_pstate and overtemp_throttling
> I added ACPI specific new events for EC desynchronization (which
> seems to be a common problem, but is entirely uninstrumented currently),
> and can lead to lost throttling events.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  Documentation/trace/events-acpi.txt  |   13 ++++++++
>  Documentation/trace/events-power.txt |   20 +++++++++++++
>  drivers/acpi/Makefile                |    1 +
>  drivers/acpi/acpi-trace.c            |    7 ++++
>  drivers/acpi/ec.c                    |    4 ++
>  drivers/acpi/processor_thermal.c     |    4 ++
>  drivers/platform/x86/intel_ips.c     |    4 ++
>  include/trace/events/power.h         |   51 ++++++++++++++++++++++++++++++++++
>  kernel/trace/power-traces.c          |    3 ++
>  9 files changed, 107 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/trace/events-acpi.txt
>  create mode 100644 drivers/acpi/acpi-trace.c
>
[...]
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -73,3 +73,4 @@ obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
>  obj-$(CONFIG_ACPI_IPMI)                += acpi_ipmi.o
>
>  obj-$(CONFIG_ACPI_APEI)                += apei/
> +obj-$(CONFIG_TRACEPOINTS)      += acpi-trace.o
> \ No newline at end of file

For what the newline is?
