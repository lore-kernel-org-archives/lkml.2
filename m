Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab2JIVWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:22:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753Ab2JIVWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:22:30 -0400
Date: Tue, 9 Oct 2012 23:22:27 +0200
From: Jan Kara <jack@suse.cz>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Zhao Hongjiang <zhaohongjiang37@gmail.com>, jack@suse.cz,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        serge.hallyn@canonical.com, containers@lists.linux-foundation.org
Subject: Re: [PATCH] ext2: fix return values on parse_options() failure
Message-ID: <20121009212227.GA27882@quack.suse.cz>
References: <5073B9C4.9070009@gmail.com>
 <alpine.LFD.2.00.1210090819590.11244@dhcp-1-104.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1210090819590.11244@dhcp-1-104.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-10-12 08:29:50, Lukáš Czerner wrote:
> On Tue, 9 Oct 2012, Zhao Hongjiang wrote:
> 
> > Date: Tue, 09 Oct 2012 13:44:36 +0800
> > From: Zhao Hongjiang <zhaohongjiang37@gmail.com>
> > To: jack@suse.cz
> > Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
> >     Eric W. Biederman <ebiederm@xmission.com>, serge.hallyn@canonical.com,
> >     containers@lists.linux-foundation.org
> > Subject: [PATCH] ext2: fix return values on parse_options() failure
> > 
> > From: Zhao Hongjiang <zhaohongjiang@huawei.com>
> > 
> > parse_options() in ext2 should return 0 when parse the mount options fails.
> > 
> > Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
> 
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
  Thanks, added to my tree.

									Honza

> > ---
> >  fs/ext2/super.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> > index 6c205d0..fa04d02 100644
> > --- a/fs/ext2/super.c
> > +++ b/fs/ext2/super.c
> > @@ -469,7 +469,7 @@ static int parse_options(char *options, struct super_block *sb)
> >  			uid = make_kuid(current_user_ns(), option);
> >  			if (!uid_valid(uid)) {
> >  				ext2_msg(sb, KERN_ERR, "Invalid uid value %d", option);
> > -				return -1;
> > +				return 0;
> > 
> >  			}
> >  			sbi->s_resuid = uid;
> > @@ -480,7 +480,7 @@ static int parse_options(char *options, struct super_block *sb)
> >  			gid = make_kgid(current_user_ns(), option);
> >  			if (!gid_valid(gid)) {
> >  				ext2_msg(sb, KERN_ERR, "Invalid gid value %d", option);
> > -				return -1;
> > +				return 0;
> >  			}
> >  			sbi->s_resgid = gid;
> >  			break;
> > -- 1.7.1
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
