Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1HVTMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 15:12:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33068 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab1HVTL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 15:11:57 -0400
Date: Mon, 22 Aug 2011 22:09:36 +0300
From: Dan Carpenter <error27@gmail.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, dan.magenheimer@oracle.com,
        ascardo@holoscopio.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: zcache: fix possible sleep under lock
Message-ID: <20110822190936.GA12248@shale.localdomain>
References: <1314038869-8164-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314038869-8164-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 01:47:49PM -0500, Seth Jennings wrote:
> zcache_new_pool() calls kmalloc() with GFP_KERNEL which has
> __GFP_WAIT set.  However, zcache_new_pool() gets called on
> a stack that holds the swap_lock spinlock, leading to a
> possible sleep-with-lock situation. The lock is obtained
> in enable_swap_info().
> 
> The patch replaces GFP_KERNEL with GFP_IOFS, which is
> GFP_KERNEL & ~__GFP_WAIT.
> 

You should use GFP_ATOMIC.  We don't want to do IO with the locks
held.  The only reason GFP_IOFS exists is so that we can turn off
io during suspend and resume.

regards,
dan carpenter

