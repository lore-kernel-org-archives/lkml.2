Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab2IFLqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:46:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2IFLqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:46:35 -0400
Message-ID: <50488D14.4010304@redhat.com>
Date: Thu, 06 Sep 2012 14:46:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
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

On 09/06/2012 02:27 PM, Tomoki Sekiyama wrote:
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

During Plumbers 2012, both Intel and AMD disclosed upcoming features to
their processors (APIC-V and AVIC) that allow directing device
interrupts to guest vcpus without host kernel involvement.  This works
without pinning, dedicating a core to a guest, or any special measures
beyond support for the feature.

CPU isolation is still useful to improve real-time latency further, but
this is really independent of kvm.

I am inclined to reject this feature in favour of the new hardware
support.  Sorry, I know this isn't nice to hear, but the extra
maintenance burden cannot be justified for a niche use case with special
limitations when generally useful feature exploiting proper hardware
support provides the same functionality.

-- 
error compiling committee.c: too many arguments to function
