Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0DIFnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 01:43:11 -0400
Received: from mail.vyatta.com ([76.74.103.46]:39277 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab0DIFnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 01:43:09 -0400
Date: Thu, 8 Apr 2010 17:52:25 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Xin, Xiaohui" <xiaohui.xin@intel.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, "mst@redhat.com" <mst@redhat.com>,
       "jdike@c2.user-mode-linux.org" <jdike@c2.user-mode-linux.org>,
       "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC] [PATCH v2 3/3] Let host NIC driver to DMA to guest user
 space.
Message-ID: <20100408175225.7577af19@nehalam>
In-Reply-To: <97F6D3BD476C464182C1B7BABF0B0AF5C17B5C2A@shzsmsx502.ccr.corp.intel.com>
References: <1270193410-6877-1-git-send-email-xiaohui.xin@intel.com>
	<20100402085556.75a8ff7c@nehalam>
	<97F6D3BD476C464182C1B7BABF0B0AF5C17B5C2A@shzsmsx502.ccr.corp.intel.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010 14:26:29 +0800
"Xin, Xiaohui" <xiaohui.xin@intel.com> wrote:

> >How do you deal with the DoS problem of hostile user space app posting huge
> >number of receives and never getting anything.   
> 
> That's a problem we are trying to deal with. It's critical for long term.
> Currently, we tried to limit the pages it can pin, but not sure how much is reasonable.
> For now, the buffers submitted is from guest virtio-net driver, so it's safe in some extent
> just for now.

It is critical even now. Once you get past toy benchmarks you will see things like
Java processes with 1000 threads all reading at once. 
