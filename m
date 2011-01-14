Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab1ANOq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:46:56 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:42175 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757363Ab1ANOqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:46:51 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 1T3FA3IVM1mjMOqjetvjo2HhKHP59NP_AFfMgXczzx.xVGw
 mBfIoQcYcAFoSxaJwhHC4PKfnFNDQTomb.sxrLcYmmBY.8sFipbHZphsJDgQ
 Bc3ZgdEvw4XDry0NtVrXAVQjH_wj6x_nePnOnHtnD_FRrlsgocteN474.6ru
 lINe2LVtZ4KlnKsj.geK3pxq9vAGB.IIF6vjJAAGh2PhTWCmuhEswWxJCxNA
 _stLOQT6.Ye4gZ3XUSz_Fspedp5QS0SDFDyzlaRaO0OKzWbxl0TjL_dcRAD0
 x3WsUoQk5yk0hwa3.LHlaMxqzOhPjXWglfTbb0l.oSLQTHuU-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 14 Jan 2011 08:46:46 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg KH <greg@kroah.com>, Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] x86: Add safe_udelay() and safe_msleep()
In-Reply-To: <4D2FA048.70909@kernel.org>
Message-ID: <alpine.DEB.2.00.1101140846340.2423@router.home>
References: <4D2BF9F3.5080709@kernel.org>  <1294731467.17779.352.camel@pasglop>  <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com>  <20110111135655.GA6901@kroah.com> <4D2CFEAD.6070206@kernel.org>  <1294799565.9586.13.camel@pasglop>
 <4D2F7AE9.2000809@kernel.org>  <20110113224450.GA14918@kroah.com>  <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6>  <4D2F84FC.7000804@kernel.org> <20110113234852.GB17904@kroah.com>  <4D2F9948.8000804@kernel.org> <1294965635.4875.8.camel@pasglop>
 <4D2FA048.70909@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Yinghai Lu wrote:

> > Or have a reasonable default for lpj ...
>
> x86 udelay is using percpu cpu_data.loops_per_jiffy, and it is not set yet.
>
> when x86 boot with earlyprintk=dbgp, that early console is loaded quite before setup_percpu_areas()
>
> maybe something like this could workaround it, if cpu_data(0) can be used before setup_percpu_areas().
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index d3cfe26..333694a 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -734,6 +734,7 @@ void __init setup_arch(char **cmdline_p)
>
>         early_trap_init();
>         early_cpu_init();
> +       cpu_data(0).loops_per_jiffy = loops_per_jiffy;
>         early_ioremap_init();
>
>         setup_olpc_ofw_pgd();

That could work.

