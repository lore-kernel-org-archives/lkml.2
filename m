Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab2IMOqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:46:11 -0400
Received: from fieldses.org ([174.143.236.118]:36544 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab2IMOqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:46:08 -0400
Date: Thu, 13 Sep 2012 10:46:02 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
Message-ID: <20120913144602.GD24684@fieldses.org>
References: <87vcfjfa14.fsf@devron.myhome.or.jp>
 <20120912171128.GG3009@fieldses.org>
 <87r4q7f8fw.fsf@devron.myhome.or.jp>
 <20120912174556.GH3009@fieldses.org>
 <87ipbjf54f.fsf@devron.myhome.or.jp>
 <CAKYAXd-5CQrE=232NKk9pRjzP3q8OBryeLt9mH==f=zrKdjzNg@mail.gmail.com>
 <87txv2cog1.fsf@devron.myhome.or.jp>
 <20120913112024.GA24684@fieldses.org>
 <87ehm6p15v.fsf@devron.myhome.or.jp>
 <CAKYAXd9a0WjZXyX43crqSKFZirE0eShk=OZNmyACn04vTrQ33A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd9a0WjZXyX43crqSKFZirE0eShk=OZNmyACn04vTrQ33A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 11:24:30PM +0900, Namjae Jeon wrote:
> 2012/9/13, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> > "J. Bruce Fields" <bfields@fieldses.org> writes:
> >
> >>> >> Grepping around... Documentation/sysctl/vm.txt mentions a
> >>> >> vfs_cache_pressure parameter.
> >>> >> Yeah. And dirty hack will be possible to adjust sb->s_shrink.batch.
> >>> > I am worrying if it could lead to OOM condition on embedded
> >>> > system(short memory(DRAM) and support 3TB HDD disk of big size.)
> >>> >
> >>> > Please let me know if any issues or queries.
> >>>
> >>> So, now I think stable inode number may be useful if there are users of
> >>> it. And I guess those functionality is no collisions with -mm. And I
> >>> suppose we can add two modes for "nfs" option (e.g. nfs=1 and nfs=2).
> >>>
> >>> If nfs=1, works like current -mm without no limited operations.
> >>
> >> Apologies, I haven't been following the conversation carefully: remind
> >> me what "works like current -mm" means?
> >
> > Current -mm means the best-effort work only if inode cache is not
> > evicted.  I.e. if there is no inode cache anymore on server, server
> > would return ESTALE. So I guess the behavior would not be stable
> > relatively.
> Hi OGAWA.
> Sorry for late response.
> Okay, I will resend patchset include your suggeston.(-o nfs=2)
> Do you mind adding busy list patch to avoid unlink issue ?
> And in case of rename, FAT retrun EBUSY while opening file.
> We can limit only rename.

The server doesn't necessarily know whether a client has the file open,
so does that really help?

--b.

> Let me know your opinion.
> 
> Thanks OGAWA!
> 
> >
> > Thanks.
> >
> >>> If nfs=2, try to make stable FH and limit some operations
> >>>
> >>> (option name doesn't matter here.)
> >>>
> >>> Does this work fine?
> > --
> > OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> >
