Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab1LZRKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 12:10:36 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:48448 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804Ab1LZRKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 12:10:34 -0500
X-IronPort-AV: E=Sophos;i="4.71,411,1320620400"; 
   d="scan'208";a="136904605"
Date: Mon, 26 Dec 2011 18:10:32 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com
cc: linux-kernel@vger.kernel.org
Subject: question about bgpio_remove (drivers/gpio/gpio-generic.c)
Message-ID: <alpine.DEB.2.02.1112261804000.1873@localhost6.localdomain6>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function bgpio_remove in the file drivers/gpio/gpio-generic.c is 
defind as follows:

int bgpio_remove(struct bgpio_chip *bgc)
{
         int err = gpiochip_remove(&bgc->gc);

 	kfree(bgc);

 	return err;
}
EXPORT_SYMBOL_GPL(bgpio_remove);

But bgc is allocated using devm_kzalloc, not kzalloc, and thus the kfree 
would seem to result in a dangling pointer.  On the other hand, this 
function does not have access to the information required to call 
devm_kfree (&pdev->dev).  Since the function is exported, should the 
interface be maintained, and the allocation of bgc converted to use 
kzalloc?  Or should the interface be changed to add the required 
information.  The callers in the kernel have the require information 
available.

thanks,
julia
