Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2JAIY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:24:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab2JAIY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:24:27 -0400
Date: Mon, 1 Oct 2012 13:54:17 +0530
From: Amit Shah <amit.shah@redhat.com>
To: sjur.brandeland@stericsson.com
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        sjurbren@stericsson.com
Subject: Re: [PATCH 3/3] virtio_console: Don't initialize buffers to zero
Message-ID: <20121001082417.GC9810@amit.redhat.com>
References: <1348580837-10919-1-git-send-email-sjur.brandeland@stericsson.com>
 <1348580837-10919-4-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348580837-10919-4-git-send-email-sjur.brandeland@stericsson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 25 Sep 2012 [15:47:17], sjur.brandeland@stericsson.com wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> 
> Skip initializing the receive buffers.

This tells 'what', but not 'why'.  Please add some more description.
For the generic virtio ports case, at least, my original thinking was
to not send random guest data to the host device.  However, we don't
have any device isolation in the host yet, and doing that will be
expensive, so it's not going to be done in the near future.. this can
be safely skipped.

Also, please make this patch 1/3, so we don't end up doing

 kzalloc->kmalloc+memset->kmalloc

Thanks,
		Amit
