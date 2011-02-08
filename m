Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1BHVDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:03:51 -0500
Received: from xenotime.net ([72.52.115.56]:50746 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755820Ab1BHVDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:03:50 -0500
Message-ID: <4D51AFBA.9080409@xenotime.net>
Date: Tue, 08 Feb 2011 13:03:54 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: james_p_freyensee@linux.intel.com
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 11/12] n_tracerouter and n_tracesink Kconfig.
References: <james_p_freyensee@linux.intel.com> <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com> <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com> <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com> <1297193697-5417-4-git-send-email-james_p_freyensee@linux.intel.com> <1297193697-5417-5-git-send-email-james_p_freyensee@linux.intel.com> <1297193697-5417-6-git-send-email-james_p_freyensee@linux.intel.com> <1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com> <1297193697-5417-8-git-send-email-james_p_freyensee@linux.intel.com> <1297193697-5417-9-git-send-email-james_p_freyensee@linux.intel.com> <1297193697-5417-10-git-send-email-james_p_freyensee@linux.intel.com> <1297193697-5417-11-git-send-email-james_p_freyensee@linux.intel.com> <1297193697-5417-12-git-send-email-james_p_freyensee@linux.intel.com>
In-Reply-To: <1297193697-5417-12-git-send-email-james_p_freyensee@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/2011 11:34 AM, james_p_freyensee@linux.intel.com wrote:
> From: J Freyensee<james_p_freyensee@linux.intel.com>
>
> This patch allows n_tracerouter and n_tracesink ldisc drivers
> to be configured in menuconfig.

s/menuconfig/kconfig tools/


> Signed-off-by: J Freyensee<james_p_freyensee@linux.intel.com>
> ---
>   drivers/char/Kconfig |   32 ++++++++++++++++++++++++++++++++
>   1 files changed, 32 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 43d3395..02b9be2 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -289,6 +289,38 @@ config N_GSM
>   	  This line discipline provides support for the GSM MUX protocol and
>   	  presents the mux as a set of 61 individual tty devices.
>
> +config TRACE_ROUTER
> +        tristate "Trace data router for MIPI P1149.7 cJTAG standard"
> +                depends on TRACE_SINK
> +                default Y

Indentation above and on the "default" below looks flaky.
Should line up with "tristate".

> +        ---help---
> +          The trace router uses the Linux tty line discipline framework to
> +          route trace data coming from a tty port (say UART for example) to
> +           the trace sink line discipline driver and to another tty port(say USB).
> +           This is part of a solution for the MIPI P1149.7, compact JTAG,
> +           standard, which is for debugging mobile devices. The PTI driver in
> +           drivers/misc/pti.c defines the majority of this MIPI solution.
> +
> +          You should select this driver if the target kernel is meant for
> +          a mobile device containing a modem.  Then you will need to select
> +          "Trace data sink for MIPI P1149.7 cJTAG standard" line discipline
> +          driver.
> +
> +config TRACE_SINK
> +        tristate "Trace data sink for MIPI P1149.7 cJTAG standard"
> +                default Y
> +        ---help---
> +          The trace sink uses the Linux line discipline framework to receive
> +          trace data coming from the trace router line discipline driver
> +          to a user-defined tty port target, like USB.
> +          This is to provide a way to extract modem trace data on
> +          devices that do not have a PTI HW module, or just need modem
> +          trace data to come out of a different HW output port.
> +          This is part of a solution for the P1149.7, compact JTAG, standard.
> +
> +          If you select this option, you need to select
> +          "Trace data router for MIPI P1149.7 cJTAG standard".
> +
>   config RISCOM8
>   	tristate "SDL RISCom/8 card support"
>   	depends on SERIAL_NONSTANDARD

