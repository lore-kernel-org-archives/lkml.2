Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab0IGTts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:49:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36367 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab0IGTtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:49:46 -0400
Date: Tue, 7 Sep 2010 12:48:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: david.cross@cypress.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] west bridge, cyasgadget fixes
Message-Id: <20100907124855.8ff2a789.randy.dunlap@oracle.com>
In-Reply-To: <1283888647.7250.28.camel@odc-laptop>
References: <1283888647.7250.28.camel@odc-laptop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Sep 2010 12:44:07 -0700 David Cross wrote:

> This patch contains update to the gadget driver, some of which are based
> on feedback from the Linux community concerning the usage of fat_get_block.
> This function call has since been removed along with all file system 
> specific calls.
> It also contains some fixes for locking issues.
> Please let me know if there are issues or concerns with this patch.
> Thanks,
> David
> 
> Signed-off-by: David Cross <david.cross@cypress.com>


Is there a patch or patch series description where the west bridge is described?

I'm asking mostly because some of the code (in the block driver patch)
looks like it should be in userspace, so I'm wondering why it's in the kernel tree?


> diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/gadget/cyasgadget.c
> --- linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-08-31 19:32:51.000000000 -0700
> +++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-09-07 11:12:44.000000000 -0700
> @@ -154,7 +154,7 @@ static void cy_as_gadget_usb_event_callb
>  		#ifndef WESTBRIDGE_NDEBUG
>  		ctrlreq = (struct usb_ctrlrequest *)evdata;
>  
> -		cy_as_hal_print_message("<1>_cy_as_event_usb_setup_packet "
> +		printk(KERN_INFO "<1>_cy_as_event_usb_setup_packet "

Drop the "<1>" ??

But lots of these are purely debug messages anyway, and shouldn't be printed
with printk(KERN_INFO ...)


>  							"received"
>  							"bRequestType=0x%x,"
>  							"bRequest=0x%x,"



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
