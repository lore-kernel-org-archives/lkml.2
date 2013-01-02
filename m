Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab3ABSqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 13:46:31 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:63843 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3ABSq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 13:46:27 -0500
Date: Wed, 2 Jan 2013 13:46:24 -0500
From: Dave Reisner <d@falconindy.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Reisner <dreisner@archlinux.org>, keescook@chromium.org,
        linux-kernel@vger.kernel.org, ludwig.nussel@suse.de
Subject: Re: [PATCH] debugfs: convert gid= argument from decimal, not octal
Message-ID: <20130102184624.GJ31925@rampage>
References: <1357134877-27141-1-git-send-email-dreisner@archlinux.org>
 <20130102183351.GA28554@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130102183351.GA28554@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 10:33:51AM -0800, Greg Kroah-Hartman wrote:
> On Wed, Jan 02, 2013 at 08:54:37AM -0500, Dave Reisner wrote:
> > This patch technically breaks userspace, but I suspect that anyone who
> > actually used this flag would have encountered this brokenness, declared
> > it lunacy, and already sent a patch.
> 
> Kees is the one that originally did this change (I think, right?)
> 
> Kees, any objection to this patch?  Will it break your existing systems?
> 
> thanks,
> 
> greg k-h
> 

Actually the original patch was provided by Ludwig Nussel (cc'd) and
commited as d6e486868cde58. Sorry, I should have mentioned at least the
commit that introduced this in the original mailing.

d

> > 
> > Signed-off-by: Dave Reisner <dreisner@archlinux.org>
> > ---
> >  fs/debugfs/inode.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> > index 153bb1e..a5f12b7 100644
> > --- a/fs/debugfs/inode.c
> > +++ b/fs/debugfs/inode.c
> > @@ -176,7 +176,7 @@ static int debugfs_parse_options(char *data, struct debugfs_mount_opts *opts)
> >  			opts->uid = uid;
> >  			break;
> >  		case Opt_gid:
> > -			if (match_octal(&args[0], &option))
> > +			if (match_int(&args[0], &option))
> >  				return -EINVAL;
> >  			gid = make_kgid(current_user_ns(), option);
> >  			if (!gid_valid(gid))
> > -- 
> > 1.8.0.3
