Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269Ab2DKWtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:49:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49475 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab2DKWtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:49:24 -0400
Date: Wed, 11 Apr 2012 15:49:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Xi Wang <xi.wang@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>
Subject: Re: [PATCH] staging: vt6656: Don't leak memory in
 drivers/staging/vt6656/ioctl.c::private_ioctl()
Message-ID: <20120411224920.GA1612@kroah.com>
References: <alpine.LNX.2.00.1204120032050.2137@swampdragon.chaosbits.net>
 <D26D474A-E696-447C-8B54-15295135368E@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D26D474A-E696-447C-8B54-15295135368E@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 06:46:33PM -0400, Xi Wang wrote:
> On Apr 11, 2012, at 6:35 PM, Jesper Juhl wrote:
> 
> > -		pNodeList = (PSNodeList)kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)), (int)GFP_ATOMIC);
> > +		pNodeList = kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)), (int)GFP_ATOMIC);
> 
> Can you also remove casts like "(int)GFP_ATOMIC"?
> 
> The parentheses "(sNodeList.uItem * sizeof(SNodeItem))" are also
> pointless..

One thing at a time, odds are this is an "automated" patch, right
Jesper?

thanks,

greg k-h
