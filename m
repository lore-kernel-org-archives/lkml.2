Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab1KVIT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 03:19:57 -0500
Received: from fmmailgate06.web.de ([217.72.192.247]:36315 "EHLO
	fmmailgate06.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab1KVIT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 03:19:56 -0500
Date: Tue, 22 Nov 2011 09:19:54 +0100 (CET)
From: "Nicolas Kalkhof" <nkalkhof@web.de>
To: "Mike Galbraith" <efault@gmx.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        maciej.rutecki@gmail.com
Message-ID: <1525712996.2585575.1321949994931.JavaMail.fmail@mwmweb003>
Subject: Re: [REGRESSION] sudden cpu hogging in kernel 3.2 rc-series
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: normal
Sensitivity: Normal
X-Provags-ID: V01U2FsdGVkX1+U7TfQcVPFXfXjSKo+nsbgGsmyI6pA1TgaI+N7VnggF+tZI/4HlFrG
 4PQiShWIe7cIFZONJXUP/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

thanks for your reply! I didn't set any polling explicitly.

My boot params are:
intel_iommu=off pcie_aspm=force i915.powersave=1 i915.i915_enable_rc6=1

and in the cpufrequtils startup daemon the only parameter set is:
# Options when starting cpufreq (given to the `cpufreq-set` program)
START_OPTS="--governor ondemand"

egrep "IDLE|GOV" .config yields:

CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_INTEL_IDLE=y
# CONFIG_I7300_IDLE is not set

Any advice?

Thanks and Regards
Nic



-----Ursprüngliche Nachricht-----
Von: "Mike Galbraith" <efault@gmx.de>
Gesendet: Nov 22, 2011 6:03:03 AM
An: "Nicolas Kalkhof" <nkalkhof@web.de>
Betreff: Re: [REGRESSION] sudden cpu hogging in kernel 3.2 rc-series

>On Mon, 2011-11-21 at 22:40 +0100, Nicolas Kalkhof wrote:
>> This happens on my machine after some minutes, too when running X and
>> the trinity desktop. the cpu continuously uses up additional ~10 watts
>> comparing to older 3.1 kernels. The issue remains high even after I
>> kill X. A closer investigation shows that poll_idle uses up the cpu
>> (see dump below). Is it normal for poll_idle to use up all ressources?
>
>poll_idle should not consume cycles on i7 unless you booted idle=poll,
>or miss-configured the kernel.
>
>egrep 'IDLE|GOV' .config
>
>CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
>CONFIG_ARCH_HAS_DEFAULT_IDLE=y
>CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
># CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
># CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
># CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
>CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
>CONFIG_CPU_FREQ_GOV_POWERSAVE=m
>CONFIG_CPU_FREQ_GOV_USERSPACE=m
>CONFIG_CPU_FREQ_GOV_ONDEMAND=m
>CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
>CONFIG_CPU_IDLE=y
>CONFIG_CPU_IDLE_GOV_LADDER=y
>CONFIG_CPU_IDLE_GOV_MENU=y
>CONFIG_INTEL_IDLE=y
>CONFIG_I7300_IDLE_IOAT_CHANNEL=y
>CONFIG_I7300_IDLE=m
>CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
>CONFIG_DEVFREQ_GOV_PERFORMANCE=y
>CONFIG_DEVFREQ_GOV_POWERSAVE=y
>CONFIG_DEVFREQ_GOV_USERSPACE=y
>
>


___________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192
