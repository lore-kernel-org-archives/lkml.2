Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab2LKWQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:16:28 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:4825 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634Ab2LKWQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:16:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmMOAEywx1B5LO66/2dsb2JhbABFhU6ycYYQF3OCHgEBBScTHCMQCAMYLhQlAyETiBC7dRSMNoNiYQOWBpBJgwc
Date: Wed, 12 Dec 2012 09:16:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 0/2] ima: policy search speedup
Message-ID: <20121211221623.GC16353@dastard>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
 <CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
 <CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
 <1355234914.2356.85.camel@falcor>
 <CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
 <CALLzPKZQ3=qNOxJk-yqDGEzqkcKLoc9tPPD8o9QbJOUOB1nWuQ@mail.gmail.com>
 <CA+55aFxh2SH9WcXbb+hD3PtWa4ZTqYNUxvbqZh27vwANuUTE8w@mail.gmail.com>
 <CACLa4pt698L4+BFSErV_rrmosmU-ELYZcmSBR8JqtYBTN35z9g@mail.gmail.com>
 <1355252842.2356.137.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355252842.2356.137.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 02:07:22PM -0500, Mimi Zohar wrote:
> On Tue, 2012-12-11 at 13:09 -0500, Eric Paris wrote:
> > On Tue, Dec 11, 2012 at 12:55 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > 
> > > And your "pseudo-filesystems" argument is pretty stupid too, since WE
> > > ALREADY HAVE A FLAG FOR THAT!
> > >
> > > Guess where it is? Oh, it's in the place I already mentioned makes
> > > more sense. Look for S_PRIVATE in inode->i_flags, and IS_PRIVATE() in
> > > users. It's what the other security models already use to avoid
> > > bothering calling down to the security layers. The fact that the
> > > integrity layer bypasses the normal security layer in
> > > ima_file_check(), for example, is no excuse to then make up totally
> > > new flags.
> > 
> > IS_PRIVATE() is not used by and darn well better not be used by, all
> > psuedo filesystems like procfs which IMA may want to ignore.  LSMs
> > like to do control on them.  I thought S_PRIVATE was really only used
> > by the anon_inode and reiserfs's really crazy ass internal inodes.  I
> > could always be wrong.
> 
> I was actually wondering about the MS_NOSEC flag.  It's currently being
> used by fuse, gfs2, ocfs2 and tmpfs.  (Not sure about xfs.)  Can someone
> explain what it is being used for?

For determining whether to clearing suid bits on writes to a
file. It defaults to on for all filesystems that use mount_bdev(),
which is just about every local filesystem (include XFS).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
