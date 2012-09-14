Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2INHmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 03:42:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36427 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2INHmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 03:42:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120913144205.GN19396@mwanda>
References: <1347462407-13499-1-git-send-email-peter.senna@gmail.com>
	<5051E9F3.4020708@bfs.de>
	<20120913144205.GN19396@mwanda>
Date: Fri, 14 Sep 2012 09:42:18 +0200
Message-ID: <CA+MoWDrHbDVkCrDt2XTadWxcb+t6D2ARMLXRkREa_mCosQusYg@mail.gmail.com>
Subject: Re: [PATCH 1/9] drivers/block/aoe/aoecmd.c: Remove useless kfree
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: walter harms <wharms@bfs.de>, "Ed L. Cashin" <ecashin@coraid.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 4:42 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Thu, Sep 13, 2012 at 04:13:07PM +0200, walter harms wrote:
>> > diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
>> > index 5461faa..cbb0521 100644
>> > --- a/drivers/block/aoe/aoecmd.c
>> > +++ b/drivers/block/aoe/aoecmd.c
>> > @@ -1257,7 +1257,6 @@ addtgt(struct aoedev *d, char *addr, ulong nframes)
>> >     }
>> >     t = kcalloc(1, sizeof *t, GFP_ATOMIC);
>> >     if (!t) {
>> > -           kfree(t);
>> >             printk(KERN_INFO "aoe: cannot allocate memory to add target\n");
>> >             return NULL;
>> >     }
>> >
>>
>>
>> this should read kzalloc(sizeof (*t), GFP_ATOMIC);
>> see: [PATCH 3/9] drivers/gpu/drm/ttm/ttm_page_alloc_dma.c: Remove useless kfree
>
> I already fixed this one last week actually.  I did it the way
> Walter suggests.
So please ignore my patch.

>
> regards,
> dan carpenter
>



-- 
Peter
