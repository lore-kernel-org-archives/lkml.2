Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab2ASMNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 07:13:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab2ASMNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 07:13:04 -0500
Date: Thu, 19 Jan 2012 09:22:09 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: no To-header on input <""@redhat.com>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] kvm: fix error handling for out of range irq
Message-ID: <20120119112209.GB11381@amt.cnet>
References: <20120118180708.GA4113@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118180708.GA4113@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 08:07:09PM +0200, Michael S. Tsirkin wrote:
> find_index_from_host_irq returns 0 on error
> but callers assume < 0 on error. This should
> not matter much: an out of range irq should never happen since
> irq handler was registered with this irq #,
> and even if it does we get a spurious msix irq in guest
> and typically nothing terrible happens.
> 
> Still, better to make it consistent.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  virt/kvm/assigned-dev.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)

Applied, thanks.

