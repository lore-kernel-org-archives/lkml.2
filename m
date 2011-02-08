Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab1BHXgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 18:36:00 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:42909
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755514Ab1BHXf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 18:35:58 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK1432N98dNzz1202hzzz2fh2a8h637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D51D341.3040209@am.sony.com>
Date: Tue, 8 Feb 2011 15:35:29 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-embedded@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove CONFIG_PM altogether, enable power management
 all the time
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201102072046.48763.rjw@sisk.pl> <20110207201803.GU10564@opensource.wolfsonmicro.com> <201102072215.59921.rjw@sisk.pl> <20110208122159.GA8284@elte.hu>
In-Reply-To: <20110208122159.GA8284@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/11 04:21, Ingo Molnar wrote:

< snip >

> Also, i've Cc:-ed Linus, to check whether the idea to make power management a 
> permanent, core portion of Linux has any obvious downsides we missed.
> 
> Rafael, could you do a defconfig-ish x86 build with and without CONFIG_PM, and post 
> the 'size vmlinux' comparison - so that we can see the size difference? We make some 
> things CONFIG_EXPERT configurable just to enable folks who *really* want to cut down 
> on kernel size to configure it out.

For 2.6.38-rc4, x86_64, CONFIG_NR_CPUS=4:

size vmlinux
   text     data       bss       dec      hex  filename

6553910  3555020   9994240  20103170  132c002  vmlinux    with    CONFIG_PM
6512652  3553116   9994240  20060008  1321768  vmlinux    without CONFIG_PM

  41258     1904         0     43162                      delta


That is big enough for me to care.

Turning on CONFIG_PM also forces a few other options on:

 295a296
 > CONFIG_XEN_SAVE_RESTORE=y
 422c423,431
 < # CONFIG_PM is not set
 ---
 > CONFIG_PM=y
 > # CONFIG_PM_DEBUG is not set
 > CONFIG_PM_SLEEP_SMP=y
 > CONFIG_PM_SLEEP=y
 > # CONFIG_SUSPEND is not set
 > # CONFIG_HIBERNATION is not set
 > # CONFIG_PM_RUNTIME is not set
 > CONFIG_PM_OPS=y
 > # CONFIG_ACPI is not set
 451,454c460
 < CONFIG_CPU_IDLE=y
 < CONFIG_CPU_IDLE_GOV_LADDER=y
 < CONFIG_CPU_IDLE_GOV_MENU=y
 < # CONFIG_INTEL_IDLE is not set
 ---
 > # CONFIG_CPU_IDLE is not set

> 
> Note that those usecases, even if they want a super-small kernel, might not care 
> about PM at all while they care about size: small boot kernels in ROMs, or simple 
> devices where CPU-idling implies deep low power mode, etc.
> 
> So the vmlinux size comparisons would be needed really. If it's 5k nobody will care. 
> If it's 50k-100k that's borderline. In the other side of the scale we have the 1500+
> #ifdef CONFIG_PM lines strewn around the kernel source, and the frequent !PM build
> breakages.
> 
> 	Ingo

-Frank

