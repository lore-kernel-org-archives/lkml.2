Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab0HKBXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 21:23:41 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46999 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314Ab0HKBXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 21:23:39 -0400
Subject: Re: [RFC PATCH v9 00/16] Provide a zero-copy method on KVM
 virtio-net.
From: Shirley Ma <mashirle@us.ibm.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
In-Reply-To: <1281086624-5765-1-git-send-email-xiaohui.xin@intel.com>
References: <1281086624-5765-1-git-send-email-xiaohui.xin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 18:23:24 -0700
Message-ID: <1281489804.3391.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Xiaohui,

On Fri, 2010-08-06 at 17:23 +0800, xiaohui.xin@intel.com wrote:
> Our goal is to improve the bandwidth and reduce the CPU usage.
> Exact performance data will be provided later. 

Have you had any performance data to share here? I tested my
experimental macvtap zero copy for TX only. The performance I have seen
as below without any tuning, (default setting):

Before: netperf 16K message size results with 60 secs run is 7.5Gb/s
over ixgbe 10GbE card. perf top shows:

2103.00 12.9% copy_user_generic_string
1541.00  9.4% handle_tx
1490.00  9.1% _raw_spin_unlock_irqrestore
1361.00  8.3% _raw_spin_lock_irqsave
1288.00  7.9% _raw_spin_lock
924.00  5.7% vhost_worker

After: netperf results with 60 secs run is 8.1Gb/s, perf output:

1093.00  9.9% _raw_spin_unlock_irqrestore
1048.00  9.5% handle_tx
934.00  8.5% _raw_spin_lock_irqsave
864.00  7.9% _raw_spin_lock
644.00  5.9% vhost_worker
387.00  3.5% use_mm 

I am still working on collecting more data (latency, cpu
utilization...). I will let you know once I get all data for macvtap TX
zero copy. Also I found some vhost performance regression on the new
kernel with tuning. I used to get 9.4Gb/s, now I couldn't get it.

Shirley
 

