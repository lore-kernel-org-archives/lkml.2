Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0KAV1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:27:17 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22960 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab0KAV1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:27:13 -0400
Date: Mon, 1 Nov 2010 22:16:40 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Tracey Dent <tdent48227@gmail.com>
cc: greg@kroah.com, manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/29] Staging: yaffs2: yaffs_checkptrw: Add files
In-Reply-To: <alpine.LNX.2.00.1011012157490.12889@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1011012214530.12889@swampdragon.chaosbits.net>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com> <1288636877-7964-8-git-send-email-tdent48227@gmail.com> <alpine.LNX.2.00.1011012157490.12889@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, Jesper Juhl wrote:

> On Mon, 1 Nov 2010, Tracey Dent wrote:
> 
[snip]
> 
> > +int yaffs2_get_checkpt_sum(yaffs_dev_t *dev, __u32 *sum)
> > +{
> > +	__u32 composite_sum;
> > +	composite_sum =  (dev->checkpt_sum << 8) | (dev->checkpt_xor & 0xFF);
> > +	*sum = composite_sum;
> > +	return 1;
> > +}
> 
> Why not
> 
> int yaffs2_get_checkpt_sum(yaffs_dev_t *dev, __u32 *sum)
> {
>      *sum  = (dev->checkpt_sum << 8) | (dev->checkpt_xor & 0xFF);
>      return 1;
> }
> 

And by the way, why is this function not returning 'void' so it just 
becomes:

void yaffs2_get_checkpt_sum(yaffs_dev_t *dev, __u32 *sum)
{
     *sum  = (dev->checkpt_sum << 8) | (dev->checkpt_xor & 0xFF);
}

Since it's always returning '1' I fail to see the point of the 'int' 
return value.

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

