Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965670Ab2DKXhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:37:23 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19189 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965399Ab2DKXhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:37:21 -0400
Date: Thu, 12 Apr 2012 01:37:19 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Xi Wang <xi.wang@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>
Subject: Re: [PATCH] staging: vt6656: Don't leak memory in
 drivers/staging/vt6656/ioctl.c::private_ioctl()
In-Reply-To: <20120411232720.GA32500@kroah.com>
Message-ID: <alpine.LNX.2.00.1204120133560.2137@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204120032050.2137@swampdragon.chaosbits.net> <D26D474A-E696-447C-8B54-15295135368E@gmail.com> <20120411224920.GA1612@kroah.com> <alpine.LNX.2.00.1204120106280.2137@swampdragon.chaosbits.net> <20120411232720.GA32500@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012, Greg Kroah-Hartman wrote:

> On Thu, Apr 12, 2012 at 01:17:52AM +0200, Jesper Juhl wrote:
> > On Wed, 11 Apr 2012, Greg Kroah-Hartman wrote:
> > 
> > > On Wed, Apr 11, 2012 at 06:46:33PM -0400, Xi Wang wrote:
> > > > On Apr 11, 2012, at 6:35 PM, Jesper Juhl wrote:
> > > > 
> > > > > -		pNodeList = (PSNodeList)kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)), (int)GFP_ATOMIC);
> > > > > +		pNodeList = kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)), (int)GFP_ATOMIC);
> > > > 
> > > > Can you also remove casts like "(int)GFP_ATOMIC"?
> > > > 
> > > > The parentheses "(sNodeList.uItem * sizeof(SNodeItem))" are also
> > > > pointless..
> > > 
> > > One thing at a time, odds are this is an "automated" patch, right
> > > Jesper?
> > > 
> > 
> > I'm not quite sure what you mean by "automated patch" Greg. Manually 
> > editing the file in emacs, then running "git format-patch", followed by 
> > importing the patch file into alpine and sending it off surely didn't 
> > feel "automated" ;-)
> 
> Sorry, I thought this was scripted, my apologies.
> 
No need for apologies. Not at all.
But I'm currious to learn that some people submit entirely 
scripted/automated patches - I didn't expect that... Ohh well, you live 
and learn ;-)


> > The only reason I even included the change of the return value cast was 
> > that it was the variable I was focusing on with regards to fixing the 
> > leak, so it felt "sufficiently related" to include in the same patch.
> > I certainly was not on a mission to clean up the file in general - just 
> > fixing the leak was all that was really on the agenda.
> > I don't *mind* fixing up other issues in the file - sure, I can do that, 
> > but that's an entirely different set of patches then...
> 
> I agree, this patch is fine as-is, thanks.
> 
You are welcome :-)

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

