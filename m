Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab0DMPGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:06:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab0DMPGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:06:05 -0400
Date: Tue, 13 Apr 2010 18:01:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Juan Quintela <quintela@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       Laurent Chavey <chavey@google.com>, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-net: fix vq_memory_access_ok error checking
Message-ID: <20100413150121.GB7716@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 09:59:10AM -0400, Jeff Dike wrote:
> vq_memory_access_ok needs to check whether mem == NULL
> 
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

This was already queued by me, you do not need to
fill Dave's inbox with vhost patches.

> ---
>  drivers/vhost/vhost.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 7bd7a1e..b8e1127 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -235,6 +235,10 @@ static int vq_memory_access_ok(void __user *log_base, struct vhost_memory *mem,
>  			       int log_all)
>  {
>  	int i;
> +
> +        if (!mem)
> +                return 0;
> +
>  	for (i = 0; i < mem->nregions; ++i) {
>  		struct vhost_memory_region *m = mem->regions + i;
>  		unsigned long a = m->userspace_addr;
> -- 
> 1.7.0.2.280.gc6f05
