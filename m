Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab0LPF4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 00:56:44 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:52512 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab0LPF4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 00:56:43 -0500
Date: Thu, 16 Dec 2010 06:56:37 +0100
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Mariusz Kozlowski <mk@lab.zgora.pl>, Chris Mason <chris.mason@oracle.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix memory leak on error path in btrfs_get_acl()
Message-ID: <20101216055637.GA4826@mako-laptop>
References: <1292450256-4544-1-git-send-email-mk@lab.zgora.pl>
 <AANLkTi=Zz8eQTS+ja59eB9-F1aE2QP5DEVCwqBP50j8K@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Zz8eQTS+ja59eB9-F1aE2QP5DEVCwqBP50j8K@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 11:49:39PM +0100, Miguel Ojeda wrote:
> On Wed, Dec 15, 2010 at 10:57 PM, Mariusz Kozlowski <mk@lab.zgora.pl> wrote:
> > If posix_acl_from_xattr() fails we leak memory stored in 'value'.
> >
> > Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
> > ---
> >  fs/btrfs/acl.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> > index 2222d16..11c9561 100644
> > --- a/fs/btrfs/acl.c
> > +++ b/fs/btrfs/acl.c
> > @@ -61,6 +61,7 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
> >                if (size > 0) {
> >                        acl = posix_acl_from_xattr(value, size);
> >                        if (IS_ERR(acl))
> > +                               kfree(value);
> 
> Be careful with the evil { }

Dang. Too much python recently i guess. Will send v2 shortly.

Thanks.

> >                                return acl;
> >                        set_cached_acl(inode, type, acl);
> >                }
> > --
> > 1.7.0.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >

-- 
Mariusz Kozlowski
