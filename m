Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0HBQKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:10:22 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49420 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab0HBQKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:10:18 -0400
Subject: Re: [RFC PATCH v8 00/16] Provide a zero-copy method on KVM
 virtio-net.
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
In-Reply-To: <20100801083113.GB16158@redhat.com>
References: <1280402088-5849-1-git-send-email-xiaohui.xin@intel.com>
	 <1280442682.9058.15.camel@localhost.localdomain>
	 <20100801083113.GB16158@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 09:10:11 -0700
Message-ID: <1280765411.22830.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michael,

On Sun, 2010-08-01 at 11:31 +0300, Michael S. Tsirkin wrote:
> Could you provide an example of a good setup?
> Specifically, is it a good idea for the vhost thread
> to inherit CPU affinities from qemu? 

I need to retest my set up with multi-threads vhost. My previous set up
applies to single thread vhost. The single stream netperf/netserver set
up, for example, if we have two quad-cores sockets to get the consistent
9.4Gb/s BW:

socket 1:
cpu0: netperf/netserver
cpu1: ixgbe 10GbE NIC IRQ 
cpu2: I/O thread
cpu3: vhost thread

socket 2:
cpu0: QEMU VCPU0
cpu1: QEMU VCPU1
cpu2:
cpu3:

Thanks
Shirley

