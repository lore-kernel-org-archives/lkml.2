Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0KSQMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:12:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab0KSQMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:12:19 -0500
Date: Fri, 19 Nov 2010 13:54:27 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Gregory Haskins <ghaskins@novell.com>,
        Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: fast-path msi injection with irqfd
Message-ID: <20101119155427.GA20279@amt.cnet>
References: <20101118170907.GA14039@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118170907.GA14039@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 07:09:08PM +0200, Michael S. Tsirkin wrote:
> Store irq routing table pointer in the irqfd object,
> and use that to inject MSI directly without bouncing out to
> a kernel thread.
> 
> While we touch this structure, rearrange irqfd fields to make fastpath
> better packed for better cache utilization.
> 
> This also adds some comments about locking rules and rcu usage in code.
> 
> Some notes on the design:
> - Use pointer into the rt instead of copying an entry,
>   to make it possible to use rcu, thus side-stepping
>   locking complexities.  We also save some memory this way.
> - Old workqueue code is still used for level irqs.
>   I don't think we DTRT with level anyway, however,
>   it seems easier to keep the code around as
>   it has been thought through and debugged, and fix level later than
>   rip out and re-instate it later.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> OK, this seems to work fine for me. Tested with virtio-net in guest
> with and without vhost-net.  Pls review/apply if appropriate.

Acked-by: Marcelo Tosatti <mtosatti@redhat.com>

