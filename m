Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900Ab1KVFDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 00:03:09 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:39574 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750748Ab1KVFDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 00:03:07 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18i6x8jPJsiD4laECSXyi5OuSRsWVFUs4EdvmPAuQ
	f8uGfcj7M7c8L2
Subject: Re: [REGRESSION] sudden cpu hogging in kernel 3.2 rc-series
From: Mike Galbraith <efault@gmx.de>
To: Nicolas Kalkhof <nkalkhof@web.de>
Cc: maciej.rutecki@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <615350841.1406384.1321911635013.JavaMail.fmail@mwmweb021>
References: <615350841.1406384.1321911635013.JavaMail.fmail@mwmweb021>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Nov 2011 06:03:03 +0100
Message-ID: <1321938183.4942.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 22:40 +0100, Nicolas Kalkhof wrote:
> This happens on my machine after some minutes, too when running X and
> the trinity desktop. the cpu continuously uses up additional ~10 watts
> comparing to older 3.1 kernels. The issue remains high even after I
> kill X. A closer investigation shows that poll_idle uses up the cpu
> (see dump below). Is it normal for poll_idle to use up all ressources?

poll_idle should not consume cycles on i7 unless you booted idle=poll,
or miss-configured the kernel.

egrep 'IDLE|GOV' .config

CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y


