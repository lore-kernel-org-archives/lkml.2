Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab0LUQFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 11:05:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab0LUQFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 11:05:45 -0500
Date: Tue, 21 Dec 2010 11:05:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: jaxboe@fusionio.com
Cc: oleg@redhat.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] blk-throttle: Couple of more fixes
Message-ID: <20101221160540.GE29522@redhat.com>
References: <1292447255-10698-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292447255-10698-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 04:07:33PM -0500, Vivek Goyal wrote:
> Hi Jens,
> 
> Please find attached couple of more fixes for blk-throttle code. These are
> based on top of "for-linus" branch of your block tree. 
> 

Hi Jens,

Do you have any concerns with these two fixes? Now Oleg and Paul have
acked it too. Could you please apply these for 2.6.38.

Thanks
Vivek

> Oleg had pointed out couple of race conditions in cgroup weight update code.
> I think these race conditions are hard to hit and not disastrous so I would
> not be too concerned about pushing these patches in 2.6.37 and can queue
> up for 2.6.38.
> 
> Paul,
> 
> Based on discussion in other mail thread, I have used xchg() based
> implementation for updating and processing limtis.  Can you please have a look
> if it is correct implementation and do I need any ACCESS_ONCE() or barriers
> somewhere. If this implementation is not correct then I can go back to atomic
> variable based implementation as suggested by you in other mail thread.
> Appreciate the help.
> 
> Thanks
> Vivek
> 
> Vivek Goyal (2):
>   blk-throttle: process limit change only through one function
>   blk-throttle: Some cleanups and race fixes in limit update code
> 
>  block/blk-throttle.c |  104 ++++++++++++++++++++------------------------------
>  1 files changed, 41 insertions(+), 63 deletions(-)
