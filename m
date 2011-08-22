Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab1HVTt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 15:49:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57665 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab1HVTtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 15:49:52 -0400
Message-ID: <4E52B2D9.5070904@linux.vnet.ibm.com>
Date: Mon, 22 Aug 2011 14:49:45 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, dan.magenheimer@oracle.com,
        ascardo@holoscopio.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: zcache: fix possible sleep under lock
References: <1314038869-8164-1-git-send-email-sjenning@linux.vnet.ibm.com> <20110822190936.GA12248@shale.localdomain>
In-Reply-To: <20110822190936.GA12248@shale.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 02:09 PM, Dan Carpenter wrote:
> On Mon, Aug 22, 2011 at 01:47:49PM -0500, Seth Jennings wrote:
>> zcache_new_pool() calls kmalloc() with GFP_KERNEL which has
>> __GFP_WAIT set.  However, zcache_new_pool() gets called on
>> a stack that holds the swap_lock spinlock, leading to a
>> possible sleep-with-lock situation. The lock is obtained
>> in enable_swap_info().
>>
>> The patch replaces GFP_KERNEL with GFP_IOFS, which is
>> GFP_KERNEL & ~__GFP_WAIT.
>>
> 
> You should use GFP_ATOMIC.  We don't want to do IO with the locks
> held.  The only reason GFP_IOFS exists is so that we can turn off
> io during suspend and resume.
> 
> regards,
> dan carpenter
> 
Actually, should this be GFP_ATOMIC or GFP_NOWAIT?

--
Seth
