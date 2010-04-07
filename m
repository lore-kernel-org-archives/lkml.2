Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0DGHxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:53:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab0DGHxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:53:01 -0400
Date: Wed, 7 Apr 2010 10:49:07 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: "Xin, Xiaohui" <xiaohui.xin@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix vq_memory_access_ok error checking
Message-ID: <20100407074907.GA7084@redhat.com>
References: <20100406201414.GA6528@c-98-229-117-200.hsd1.ma.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406201414.GA6528@c-98-229-117-200.hsd1.ma.comcast.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 04:14:14PM -0400, Jeff Dike wrote:
> Here's another small patch fixing an error path...
> 
> 			Jeff
> 
> -- 
> Work email - jdike at linux dot intel dot com
> 
> 
> commit 7938779d9f357ede8bc3c122fd0dc9d5ec4fcf1d
> Author: Jeff Dike <jdike@addtoit.com>
> Date:   Wed Mar 31 15:05:08 2010 -0400
> 
>     vq_memory_access_ok needs to check whether mem == NULL

Thanks!
Can you add a Signed-off-by line?

The sign-off is a simple line at the end of the explanation for the
patch, which certifies that you wrote it or otherwise have the right to
pass it on as a open-source patch.  The rules are pretty simple: if you
can certify the below:

        Developer's Certificate of Origin 1.1

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

	(d) I understand and agree that this project and the contribution
	    are public and that a record of the contribution (including all
	    personal information I submit with it, including my sign-off) is
	    maintained indefinitely and may be redistributed consistent with
	    this project or the open source license(s) involved.

then you just add a line saying

	Signed-off-by: Random J Developer <random@developer.example.org>

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
