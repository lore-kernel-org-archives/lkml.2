Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab1F2VlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:41:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309Ab1F2VlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:41:05 -0400
Date: Wed, 29 Jun 2011 17:40:56 -0400
From: David Teigland <teigland@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Christine Caulfield <ccaulfie@redhat.com>
Subject: Re: [PATCH] fs, dlm: Don't leak, don't do pointless NULL checks and
 use kzalloc
Message-ID: <20110629214056.GA11350@redhat.com>
References: <alpine.LNX.2.00.1106292304380.3747@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106292304380.3747@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 11:09:27PM +0200, Jesper Juhl wrote:
> In fs/dlm/lock.c in the dlm_scan_waiters() function there are 3 small
> issues:
> 
> 1) first time through the loop we allocate memory for 'warned', if we
> then (in the loop) don't take the "if (!warned)" path and loop again,
> the second time through the loop we'll allocate memory again and store
> it to 'warned' without freeing the previous allocation - this leaks
> memory.

I don't think so; num_nodes won't be set to zero.

> 2) There's no need to test the return value of the allocation and do a
> memset if is succeedes. Just use kzalloc() to obtain zeroed memory.

fine

> 3) Since kfree() handles NULL pointers gracefully, the test of
> 'warned' against NULL before the kfree() after the loop is completely
> pointless. Remove it.

fine

ack if you want to push those two out yourself.
Dave
