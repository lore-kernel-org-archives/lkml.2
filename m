Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2DMSjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:39:23 -0400
Received: from smtp.citrix.com ([66.165.176.89]:57374 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab2DMSjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:39:21 -0400
X-IronPort-AV: E=Sophos;i="4.75,418,1330923600"; 
   d="scan'208";a="24148042"
Message-ID: <4F8872D7.7050507@citrix.com>
Date: Fri, 13 Apr 2012 19:39:19 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Sheng Yang <sheng@yasker.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Tim (Xen.org)" <tim@xen.org>,
        Jan Beulich <jbeulich@suse.com>
Subject: Re: [PATCH] xen: always set the sched clock as unstable
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com>  <CA+2rt41ctpU-vhR7=u_r45=o8djpq0-5YE5jcj_4FR2bWYu5pQ@mail.gmail.com>
In-Reply-To: <CA+2rt41ctpU-vhR7=u_r45=o8djpq0-5YE5jcj_4FR2bWYu5pQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/04/12 19:31, Sheng Yang wrote:
> On Fri, Apr 13, 2012 at 11:20 AM, David Vrabel <david.vrabel@citrix.com
> <mailto:david.vrabel@citrix.com>> wrote:
> 
>     From: David Vrabel <david.vrabel@citrix.com
>     <mailto:david.vrabel@citrix.com>>
> 
>     The sched clock was considered stable based on the capabilities of the
>     underlying hardware.  This does not make sense for Xen PV guests as:
>     a) the hardware TSC is not used directly as the clock source; and b)
>     guests may migrate to hosts with different hardware capabilities.
> 
>     It is not clear to me whether the Xen clock source is supposed to be
>     stable and whether it should be stable across migration.  For a clock
>     source to be stable it must be: a) monotonic; c) synchronized across
>     CPUs; and c) constant rate.
> 
>     There have also been reports of systems with apparently unstable
>     clocks where clearing sched_clock_stable has fixed problems with
>     migrated VMs hanging.
> 
>     So, always set the sched clock as unstable when using the Xen clock
>     source.
> 
>     Signed-off-by: David Vrabel <david.vrabel@citrix.com
>     <mailto:david.vrabel@citrix.com>>
>     ---
>      arch/x86/xen/time.c |    1 +
>      1 files changed, 1 insertions(+), 0 deletions(-)
> 
>     diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
>     index 0296a95..8469b5a 100644
>     --- a/arch/x86/xen/time.c
>     +++ b/arch/x86/xen/time.c
>     @@ -473,6 +473,7 @@ static void __init xen_time_init(void)
>            do_settimeofday(&tp);
> 
>            setup_force_cpu_cap(X86_FEATURE_TSC);
>     +       sched_clock_stable = 0;
> 
>            xen_setup_runstate_info(cpu);
>            xen_setup_timer(cpu);
>     --
>     1.7.2.5
> 
> 
> I really prefer to hide nonstop tsc feature from Xen side, rather than
> let Linux kernel to have a condition that "Nonstop TSC feature existed,
> but sched_clock_stable=0".

I disagree.  The decision on whether the clock is stable or not should
be in the Xen clock source code.

David
