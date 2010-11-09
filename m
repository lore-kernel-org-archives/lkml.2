Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab0KIMyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:54:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab0KIMy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:54:29 -0500
Date: Tue, 9 Nov 2010 07:53:50 -0500
From: Josef Bacik <josef@redhat.com>
To: Will Newton <will.newton@gmail.com>
Cc: Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, joel.becker@oracle.com,
        cmm@us.ibm.com, cluster-devel@redhat.com
Subject: Re: [PATCH 5/6] Btrfs: fail if we try to use hole punch
Message-ID: <20101109125350.GE27816@dhcp231-156.rdu.redhat.com>
References: <1289248327-16308-1-git-send-email-josef@redhat.com> <1289248327-16308-5-git-send-email-josef@redhat.com> <AANLkTiksTsZqo1yUNVEJSiwE-7ccyWDv+wLvTZaoZOJ0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTiksTsZqo1yUNVEJSiwE-7ccyWDv+wLvTZaoZOJ0@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 10:05:34AM +0000, Will Newton wrote:
> On Mon, Nov 8, 2010 at 8:32 PM, Josef Bacik <josef@redhat.com> wrote:
> 
> Hi Josef,
> 
> > Btrfs doesn't have the ability to punch holes yet, so make sure we return
> > EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
> > be added later.  Thanks,
> >
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> >  fs/btrfs/inode.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 78877d7..c590add 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -6936,6 +6936,10 @@ static long btrfs_fallocate(struct inode *inode, int mode,
> >        alloc_start = offset & ~mask;
> >        alloc_end =  (offset + len + mask) & ~mask;
> >
> > +       /* We only support the FALLOC_FL_KEEP_SIZE mode */
> > +       if (mode && (mode & FALLOC_FL_KEEP_SIZE))
> > +               return -EOPNOTSUPP;
> > +
> 
> This test looks rather odd. Why do we need to test that mode is
> non-zero AND that mode has a specific bit set? Is there a missing !
> here?

Yeah I'm missing a !, I copy and pasted the wrong bit when I went around adding
this check to everybody, I'll be fixing it up for the next go around.  Thanks,

Josef
