Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab0KGWmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 17:42:52 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:45496 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751981Ab0KGWmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 17:42:51 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH 2/9] Add yaffs allocator, bitmap and attrib source
Date: Mon, 8 Nov 2010 11:42:47 +1300
User-Agent: KMail/1.9.10
Cc: Charles Manning <cdhmanning@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <1288803204-3849-3-git-send-email-cdhmanning@gmail.com> <alpine.LNX.2.00.1011042357380.16015@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1011042357380.16015@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011081142.48215.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 November 2010 12:01:07 Jesper Juhl wrote:
> On Thu, 4 Nov 2010, cdhmanning@gmail.com wrote:
> [snip]
>
> > +void yaffs_free_raw_obj(struct yaffs_dev *dev, struct yaffs_obj *obj)
> > +{
> > +
> > +     struct yaffs_allocator *allocator = dev->allocator;
> > +
> > +     if (!allocator)
> > +             YBUG();
> > +     else {
> > +             /* Link into the free list. */
> > +             obj->siblings.next = (struct list_head
> > *)(allocator->free_objs); +             allocator->free_objs = obj;
> > +             allocator->n_free_objects++;
> > +     }
> > +}
> > +
> > +void yaffs_deinit_raw_tnodes_and_objs(struct yaffs_dev *dev)
> > +{
> > +     if (dev->allocator) {
> > +             yaffs_deinit_raw_tnodes(dev);
> > +             yaffs_deinit_raw_objs(dev);
> > +
> > +             YFREE(dev->allocator);
> > +             dev->allocator = NULL;
> > +     } else
> > +             YBUG();
> > +}
> > +
> > +void yaffs_init_raw_tnodes_and_objs(struct yaffs_dev *dev)
> > +{
> > +     struct yaffs_allocator *allocator;
> > +
> > +     if (!dev->allocator) {
> > +             allocator = YMALLOC(sizeof(struct yaffs_allocator));
> > +             if (allocator) {
> > +                     dev->allocator = allocator;
> > +                     yaffs_init_raw_tnodes(dev);
> > +                     yaffs_init_raw_objs(dev);
> > +             }
> > +     } else
> > +             YBUG();
> > +}
>
> Tiny style issue; Documentation/CodingStyle says:
>
> "Do not unnecessarily use braces where a single statement will do.
>
> if (condition)
>         action();
>
> This does not apply if one branch of a conditional statement is a single
> statement. Use braces in both branches.
>
> if (condition) {
>         do_this();
>         do_that();
> } else {
>         otherwise();
> }
> "
>
> So, in the above, you should have curly braces around both the 'if' and
> 'else' parts since one of them is more than one statement.

Thanks Jesper

Aargh!!  I had the code  the right way and changed it! My bad for misreading 
the CodingStyle.

I have corrected this for the next patch drop, probably a week out.

-- Charles
