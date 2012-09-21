Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab2IULhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 07:37:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47881 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab2IULhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 07:37:54 -0400
Date: Fri, 21 Sep 2012 14:37:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: maximlevitsky@gmail.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: re: memstick: add support for legacy memorysticks
Message-ID: <20120921113745.GA21483@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maxim Levitsky,

The patch d59dd7c61b24: "memstick: add support for legacy 
memorysticks" from Sep 21, 2012, leads to the following warning:
drivers/memstick/core/ms_block.c:147 sg_compare_to_buffer()
	 warn: signedness bug returning '-1'

   141  
   142          if (!retval && len)
   143                  retval = -1;
                        ^^^^^^^^^^^
   144  
   145          sg_miter_stop(&miter);
   146          local_irq_restore(flags);
   147          return retval;
   148  }

This function is bool so it always returns true if len is non-zero.

The comments at the top of the function don't talk about if a 1 means
the same and 0 means different or if it's the other way around.

regards,
dan carpenter

