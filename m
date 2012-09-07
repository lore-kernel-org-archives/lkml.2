Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896Ab2IGI12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:27:28 -0400
Received: from thoth.sbs.de ([192.35.17.2]:30134 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860Ab2IGI1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:27:25 -0400
Message-ID: <5049AFD0.1060700@siemens.com>
Date: Fri, 07 Sep 2012 10:26:56 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC v2 PATCH 00/21] KVM: x86: CPU isolation and direct interrupts
 delivery to guests
References: <20120906112718.13320.8231.stgit@kvmdev>
In-Reply-To: <20120906112718.13320.8231.stgit@kvmdev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-06 13:27, Tomoki Sekiyama wrote:
> This RFC patch series provides facility to dedicate CPUs to KVM guests
> and enable the guests to handle interrupts from passed-through PCI devices
> directly (without VM exit and relay by the host).
> 
> With this feature, we can improve throughput and response time of the device
> and the host's CPU usage by reducing the overhead of interrupt handling.
> This is good for the application using very high throughput/frequent
> interrupt device (e.g. 10GbE NIC).
> Real-time applicatoins also gets benefit from CPU isolation feature, which
> reduces interfare from host kernel tasks and scheduling delay.
> 
> The overview of this patch series is presented in CloudOpen 2012.
> The slides are available at:
> http://events.linuxfoundation.org/images/stories/pdf/lcna_co2012_sekiyama.pdf

One question regarding your benchmarks: If you measured against standard
KVM, were the vCPU thread running on an isolcpus core of its own as
well? If not, your numbers about the impact of these patches on maximum,
maybe also average latencies are likely too good. Also, using a non-RT
host and possibly a non-prioritized vCPU thread for the standard
scenario looks like an unfair comparison.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux
