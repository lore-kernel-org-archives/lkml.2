Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab1FBKdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 06:33:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932591Ab1FBKdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 06:33:50 -0400
Date: Thu, 2 Jun 2011 13:34:06 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Mark Wu <dwu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index
Message-ID: <20110602103406.GD7943@redhat.com>
References: <1306913069-23637-1-git-send-email-dwu@redhat.com>
 <4DE5F78C.1010102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE5F78C.1010102@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 04:25:48AM -0400, Mark Wu wrote:
> On 06/01/2011 03:24 AM, Mark Wu wrote:
> >-	if (index_to_minor(index)>= 1<<  MINORBITS)
> >-		return -ENOSPC;
> >+	do {
> >+		if (!ida_pre_get(&vd_index_ida, GFP_KERNEL))
> >+			return err;
> >+
> There's a problem in above code: err is not initialized before
> using, so change it to return -1;
> +       do {
> +               if (!ida_pre_get(&vd_index_ida, GFP_KERNEL))
> +                       return -1;

Not -1. Pls return -ENOMEM.

