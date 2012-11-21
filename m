Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2KUTwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:52:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44984 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab2KUTwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:52:53 -0500
Date: Wed, 21 Nov 2012 11:52:47 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Subject: Re: [PATCH RFC 10/12] userns: Convert xfs to use kuid/kgid/kprojid
 where appropriate
Message-ID: <20121121195246.GN2822@localhost>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-fsdevel@vger.kernel.org,
	Linux Containers <containers@lists.linux-foundation.org>,
	linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
	Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
References: <87pq38wimv.fsf@xmission.com>
 <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
 <1353415420-5457-10-git-send-email-ebiederm@xmission.com>
 <20121120235524.GK2591@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120235524.GK2591@dastard>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 10:55:24AM +1100, Dave Chinner wrote:
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 2778258..3656b88 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -570,11 +570,12 @@ xfs_dinode_from_disk(
> >  	to->di_version = from ->di_version;
> >  	to->di_format = from->di_format;
> >  	to->di_onlink = be16_to_cpu(from->di_onlink);
> > -	to->di_uid = be32_to_cpu(from->di_uid);
> > -	to->di_gid = be32_to_cpu(from->di_gid);
> > +	to->di_uid = make_kuid(&init_user_ns, be32_to_cpu(from->di_uid));
> > +	to->di_gid = make_kgid(&init_user_ns, be32_to_cpu(from->di_gid));
> 
> You can't do this, because the incore inode structure is written
> directly to the log. This is effectively an on-disk format change.

	Yeah, I don't get this either.  Over in ocfs2, you do the
correct thing, translating at the boundary from ocfs2_dinode to struct
inode.

Joel

-- 

"I always thought the hardest questions were those I could not answer.
 Now I know they are the ones I can never ask."
			- Charlie Watkins

			http://www.jlbec.org/
			jlbec@evilplan.org
