Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab0KDXMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 19:12:06 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27843 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab0KDXME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 19:12:04 -0400
Date: Fri, 5 Nov 2010 00:01:07 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Charles Manning <cdhmanning@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/9] Add yaffs allocator, bitmap and attrib source
In-Reply-To: <1288803204-3849-3-git-send-email-cdhmanning@gmail.com>
Message-ID: <alpine.LNX.2.00.1011042357380.16015@swampdragon.chaosbits.net>
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <1288803204-3849-3-git-send-email-cdhmanning@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010, cdhmanning@gmail.com wrote:
[snip]
> +void yaffs_free_raw_obj(struct yaffs_dev *dev, struct yaffs_obj *obj)
> +{
> +      
> +     struct yaffs_allocator *allocator = dev->allocator;
> +     
> +     if (!allocator)
> +             YBUG();
> +     else {
> +             /* Link into the free list. */
> +             obj->siblings.next = (struct list_head *)(allocator->free_objs);
> +             allocator->free_objs = obj;
> +             allocator->n_free_objects++;
> +     }
> +}
> +             
> +void yaffs_deinit_raw_tnodes_and_objs(struct yaffs_dev *dev)
> +{
> +     if (dev->allocator) {
> +             yaffs_deinit_raw_tnodes(dev);
> +             yaffs_deinit_raw_objs(dev);
> +     
> +             YFREE(dev->allocator);
> +             dev->allocator = NULL;
> +     } else
> +             YBUG();
> +}
> +             
> +void yaffs_init_raw_tnodes_and_objs(struct yaffs_dev *dev)
> +{
> +     struct yaffs_allocator *allocator;  
> +      
> +     if (!dev->allocator) {
> +             allocator = YMALLOC(sizeof(struct yaffs_allocator));
> +             if (allocator) {
> +                     dev->allocator = allocator;
> +                     yaffs_init_raw_tnodes(dev);
> +                     yaffs_init_raw_objs(dev);
> +             }
> +     } else
> +             YBUG();
> +}

Tiny style issue; Documentation/CodingStyle says:

"Do not unnecessarily use braces where a single statement will do.

if (condition)
        action();

This does not apply if one branch of a conditional statement is a single
statement. Use braces in both branches.

if (condition) {
        do_this();
        do_that();
} else {
        otherwise();
}
"

So, in the above, you should have curly braces around both the 'if' and 
'else' parts since one of them is more than one statement.



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

