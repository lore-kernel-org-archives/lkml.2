Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab2BNXAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 18:00:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53413 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2BNXAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 18:00:44 -0500
MIME-Version: 1.0
In-Reply-To: <4F3AD3B6.8070409@linux.vnet.ibm.com>
References: <CABeCy1aPp4=v90v_wAsw-KWDwNs59CwwYSJ-36+4t8kMuCaK0w@mail.gmail.com>
	<1328055439-9441-1-git-send-email-venki@google.com>
	<20120201140125.c656df41.akpm@linux-foundation.org>
	<87d39xj955.fsf@rustcorp.com.au>
	<CA+8MBbJcTgj7X-7RZAgWk8a3Qyaz1FxFzu3ZLk-8LHKD7M8h-Q@mail.gmail.com>
	<4F3971A1.5010305@linux.vnet.ibm.com>
	<4F39763D.3070609@linux.vnet.ibm.com>
	<CA+8MBbLR+rcJqe2z9tAt7Oav4wqgZA3k8Te6zcXNOs+zv2wAaA@mail.gmail.com>
	<87wr7pbwbz.fsf@rustcorp.com.au>
	<4F3AD3B6.8070409@linux.vnet.ibm.com>
Date: Tue, 14 Feb 2012 15:00:43 -0800
X-Google-Sender-Auth: RC2QC_OmvTYjQpsP5z4q0t6qB_M
Message-ID: <CA+8MBbLZhacoWj03bLciA-r+wrfyW03C3QrXgWuBrM3axBdGAg@mail.gmail.com>
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus -v5
From: Tony Luck <tony.luck@intel.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 1:35 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Right. And we should also ensure that nobody messes directly with
> cpu_possible_map as well. I have written up a patch for ia64 (see below).
> Sorry, I haven't even compile tested it - I neither have the toolchain nor the
> hardware. I hope it works!

Thanks for doing this - compiles and seems to work.

Tested-by: Tony Luck <tony.luck@intel.com>

Can we get this added to the series - so it gets applied along with
Venki's patch.

>  0 files changed, 0 insertions(+), 0 deletions(-)

I think your patch generation script needs some attention - I see
 arch/ia64/kernel/setup.c   |    2 +-
 arch/ia64/kernel/smp.c     |    2 +-
 arch/ia64/kernel/smpboot.c |   12 ++++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

> @@ -609,7 +609,7 @@ smp_prepare_cpus (unsigned int max_cpus)
>        /*
>         * We have the boot CPU online for sure.
>         */
> -       cpu_set(0, cpu_online_map);
> +       set_cpu_online(0, true);
>        cpu_set(0, cpu_callin_map);
>
>        local_cpu_data->loops_per_jiffy = loops_per_jiffy;

Generic code has already marked cpu 0 online ... so this one could
just be dropped (and the preceding comment too). Though it does no
harm to set it again.

-Tony
