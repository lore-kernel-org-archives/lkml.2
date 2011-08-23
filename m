Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1HWApJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:45:09 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38310 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754606Ab1HWAoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:44:46 -0400
X-Sasl-enc: C8sWugYNNEdiddWQWZqxQW3M3kJ2++6J8MJn1R+q5v6u 1314060285
Date: Mon, 22 Aug 2011 17:38:14 -0700
From: Greg KH <greg@kroah.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] libfs: fix simple_attr_write on 32bit machine
Message-ID: <20110823003814.GB5982@kroah.com>
References: <1310187626-2371-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310187626-2371-1-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 09, 2011 at 02:00:26PM +0900, Akinobu Mita wrote:
> Assume that /sys/kernel/debug/dummy64 is debugfs file created by
> debugfs_create_x64().
> 
> 	# cd /sys/kernel/debug
> 	# echo 0x1234567812345678 > dummy64
> 	# cat dummy64
> 	0x0000000012345678
> 
> 	# echo 0x80000000 > dummy64
> 	# cat dummy64
> 	0xffffffff80000000
> 
> The value more than INT_MAX cannot be written to the debugfs file
> created by debugfs_create_u64 or debugfs_create_x64 on 32bit machine.
> Because simple_attr_write() uses simple_strtol() for the conversion.
> 
> To fix this, use simple_strtoll() instead.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Do we have any debugfs files that need this change in the tree now for
3.1 or newer?

thanks,

greg k-h
